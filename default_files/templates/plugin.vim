""" Test Ally Vim plugin
"hi  HitLine     ctermbg=Cyan     guibg=Cyan
"hi  MissLine    ctermbg=Magenta  guibg=Magenta
"hi  IgnoreLine  ctermbg=Black    guibg=Black
hi  HitSign     ctermfg=6      cterm=bold   gui=bold    guifg=Green
hi  MissSign    ctermfg=Red    cterm=bold   gui=bold    guifg=Red
hi  IgnoreSign  ctermfg=6      cterm=bold   gui=bold    guifg=Grey
"
sign  define  hit      linehl=HitLine      texthl=HitSign      text=✔
sign  define  miss     linehl=MissLine     texthl=MissSign     text=✘
sign  define  ignored  linehl=IgnoredLine  texthl=IgnoredSign  text=◌

let s:coverageFileRelPath = "coverage/coverage.vim"

let s:coverageFtimes = {}
let s:allCoverage = {}

function! AddSimplecovResults(file, results)
  let s:allCoverage[fnamemodify(a:file, ":p")] = a:results
endfunction

function! s:LoadAllCoverage(file)
  let l:ftime = getftime(a:file)
  if(!has_key(s:coverageFtimes, a:file) || (s:coverageFtimes[a:file] < l:ftime))
    if(has_key(s:allCoverage, a:file))
      unlet s:allCoverage[a:file]
    endif
    exe "source ".a:file
    let s:coverageFtimes[a:file] = l:ftime
  endif
endfunction

function! s:BestCoverage(coverageFile, coverageForName)
  let matchBadness = strlen(a:coverageForName)
  for filename in keys(s:allCoverage[a:coverageFile])
    let matchQuality = match(a:coverageForName, filename . "$")
    if (matchQuality >= 0 && matchQuality < matchBadness)
      let found = filename
    endif
  endfor

  if exists("found")
    let b:lineCoverage = s:allCoverage[a:coverageFile][l:found]
  else
    echom "No coverage recorded for " . a:coverageForName
    let b:lineCoverage = {'hits': [], 'misses': [], 'ignored': [] }
  endif
endfunction

function! s:LoadFileCoverage(codeFile)
  let l:coverageFile = fnamemodify(findfile(s:coverageFileRelPath,'.;'), ":p")
  call s:LoadAllCoverage(coverageFile)
  if (has_key(s:coverageFtimes, l:coverageFile) && getftime(a:codeFile) > s:coverageFtimes[l:coverageFile])
    echom "File is newer than coverage report which was generated at " . strftime("%c", s:coverageFTimes[l:coverageFile])
  endif
  call s:BestCoverage(l:coverageFile, a:codeFile)
endfunction

function s:SetSign(filename, line, type)
  let id = b:coverageSignIndex
  let b:coverageSignIndex += 1
  let b:coverageSigns += [id]
  exe ":sign place ".id." line=".a:line." name=".a:type." file=" . a:filename
endfunction

"XXX locating buffer + codeFile...
function! s:SetCoverageSigns(filename)
  call s:LoadFileCoverage(a:filename)
  call s:ClearCoverageSigns()

  if (! exists("b:coverageSigns"))
    let b:coverageSigns = []
  endif

  if (! exists("b:coverageSignIndex"))
    let b:coverageSignIndex = 1
  endif

  for line in b:lineCoverage['hits']
    call s:SetSign(a:filename, l:line, 'hit')
  endfor

  for line in b:lineCoverage['misses']
    call s:SetSign(a:filename, l:line, 'miss')
  endfor

  for line in b:lineCoverage['ignored']
    call s:SetSign(a:filename, l:line, 'ignored')
  endfor
endfunction

function! s:ClearCoverageSigns()
  if(exists("b:coverageSigns"))
    for signId in b:coverageSigns
      exe ":sign unplace ".signId
    endfor
    unlet! b:coverageSigns
  endif
endfunction

let s:filename = expand("<sfile>")
function! s:AutocommandUncov(sourced)
  if(a:sourced == s:filename)
    call s:ClearCoverageSigns(expand("%:p"))
  endif
endfunction

command! -nargs=0 Cov call s:CoverageSigns(expand("%:p"))
command! -nargs=0 Uncov call s:ClearCoverageSigns(expand("%:p"))

augroup SimpleCov
  au!
  au BufWinEnter *.rb call s:SetCoverageSigns(expand('<afile>:p'))
augroup end
