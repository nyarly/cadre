""" Test Ally Vim plugin
"hi  HitLine     ctermbg=Cyan     guibg=Cyan
"hi  MissLine    ctermbg=Magenta  guibg=Magenta
"hi  IgnoreLine  ctermbg=Black    guibg=Black

hi  HitSign     ctermfg=6      cterm=bold   gui=bold    guifg=Green
hi  MissSign    ctermfg=Red    cterm=bold   gui=bold    guifg=Red
hi  IgnoredSign ctermfg=6      cterm=bold   gui=bold    guifg=Grey
"
sign  define  hit      linehl=HitLine      texthl=HitSign      text=✔
sign  define  miss     linehl=MissLine     texthl=MissSign     text=✘
sign  define  ignored  linehl=IgnoredLine  texthl=IgnoredSign  text=◌

let s:coverageFileRelPath = ".cadre/coverage.vim"

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
  let b:coverageFtime = s:coverageFtimes[a:file]
endfunction

function! s:BestCoverage(coverageFile, coverageForName)
  let matchBadness = strlen(a:coverageForName)
  if(has_key(s:allCoverage, a:coverageFile))
    for filename in keys(s:allCoverage[a:coverageFile])
      let matchQuality = match(a:coverageForName, filename . "$")
      if (matchQuality >= 0 && matchQuality < matchBadness)
        let matchBadness = matchQuality
        let found = filename
      endif
    endfor
  endif

  if exists("found")
    let b:lineCoverage = s:allCoverage[a:coverageFile][l:found]
    let b:coverageName = found
  else
    let b:coverageName = '(none)'
    call s:emptyCoverage(a:coverageForName)
  endif
endfunction

function! s:emptyCoverage(coverageForName)
  echom "No coverage recorded for " . a:coverageForName
  let b:lineCoverage = {'hits': [], 'misses': [], 'ignored': [] }
endfunction

function! s:FindCoverageFile(codeFile)
  let found_coverage = findfile(s:coverageFileRelPath,fnamemodify(a:codeFile, ':p:h').";")
  if(found_coverage == '')
    return ''
  else
    return fnamemodify(found_coverage, ":p")
  end
endfunction

function! s:LoadFileCoverage(codeFile, coverageFile)
  call s:LoadAllCoverage(a:coverageFile)
  call s:BestCoverage(a:coverageFile, a:codeFile)
endfunction

function s:SetSign(filename, line, type)
  let id = b:coverageSignIndex
  let b:coverageSignIndex += 1
  let b:coverageSigns += [id]
  exe ":sign place ".id." line=".a:line." name=".a:type." file=" . a:filename
endfunction

"XXX locating buffer + codeFile...
function! s:SetCoverageSigns(filename)
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

function! s:MarkUpBuffer(filepath)
  let coverageFile = s:FindCoverageFile(a:filepath)

  if(coverageFile == '')
    echom "No coverage file"
    return
  endif

  if(exists("b:coverageFtime") && getftime(coverageFile) <= b:coverageFtime)
    "Coverage already done"
    return
  endif

  if(&modified)
    echom "Buffer modified - coverage signs would likely be wrong"
    return
  endif

  if(getftime(a:filepath) > getftime(coverageFile))
    echom "Code file is newer that coverage file - signs would likely be wrong"
    return
  endif

  call s:LoadFileCoverage(a:filepath, l:coverageFile)
  call s:ClearCoverageSigns()
  call s:SetCoverageSigns(a:filepath)
endfunction

let s:filename = expand("<sfile>")
function! s:AutocommandUncov(sourced)
  if(a:sourced == s:filename)
    call s:ClearCoverageSigns(expand("%:p"))
  endif
endfunction

command! -nargs=0 Cov call s:SetCoverageSigns(expand("%:p"))
command! -nargs=0 Uncov call s:ClearCoverageSigns()

augroup SimpleCov
  au!
  au BufWinEnter *.rb call s:MarkUpBuffer(expand('<afile>:p'))
augroup end
