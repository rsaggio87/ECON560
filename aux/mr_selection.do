clear all
set seed 90210
set obs 500

local rho = 0.5
local kA  = 0.2
local kB  = 3

gen ew = rnormal()
gen z  = rnormal()
gen er = `rho'*ew + sqrt(1-`rho'^2)*z

gen workA = (er < `kA'*ew)
gen workB = (er < `kB'*ew)

quietly sum ew if workA==1
local bA : display %4.2f r(mean)
quietly sum workA
local pA : display %3.2f r(mean)
quietly sum ew if workB==1
local bB : display %4.2f r(mean)
quietly sum workB
local pB : display %3.2f r(mean)

twoway (scatter er ew if workA==0, msymbol(Oh) msize(small) mcolor(gs11))      ///
       (scatter er ew if workA==1, msymbol(O)  msize(small) mcolor(navy))      ///
       (function y = `kA'*x, range(-3 3) lpattern(dash) lwidth(medthick)        ///
            lcolor(black)),                                                     ///
       xline(`bA', lcolor(cranberry) lwidth(medthick) lpattern(solid))                          ///
       title("Panel A: low {&sigma}{superscript:w}", size(medium))              ///
       subtitle("{&sigma}{superscript:w}/{&sigma}{superscript:r} = 0.2", size(small)) ///
       xtitle("{&epsilon}{superscript:w}{subscript:i}") ytitle("{&epsilon}{superscript:r}{subscript:i}") ///
       xlabel(-3(1)3, nogrid) ylabel(-3(1)3, nogrid) xscale(range(-3 3)) yscale(range(-3 3))    ///
       text(-2.3 1.9 "work", color(navy) size(medium))                           ///
       text(2.3 -1.9 "don't work", color(gs8) size(medium))                      ///
       text(2.55 `bA' "b{subscript:t} = E[{&epsilon}{superscript:w}|work] = `bA'", color(cranberry) size(medsmall) placement(e)) ///
       legend(off) graphregion(color(white)) name(A, replace)

twoway (scatter er ew if workB==0, msymbol(Oh) msize(small) mcolor(gs11))      ///
       (scatter er ew if workB==1, msymbol(O)  msize(small) mcolor(navy))      ///
       (function y = `kB'*x, range(-1 1) lpattern(dash) lwidth(medthick)        ///
            lcolor(black)),                                                     ///
       xline(`bB', lcolor(cranberry) lwidth(medthick) lpattern(solid))                          ///
       title("Panel B: high {&sigma}{superscript:w}", size(medium))             ///
       subtitle("{&sigma}{superscript:w}/{&sigma}{superscript:r} = 3", size(small)) ///
       xtitle("{&epsilon}{superscript:w}{subscript:i}") ytitle("{&epsilon}{superscript:r}{subscript:i}") ///
       xlabel(-3(1)3, nogrid) ylabel(-3(1)3, nogrid) xscale(range(-3 3)) yscale(range(-3 3))    ///
       text(-2.3 1.9 "work", color(navy) size(medium))                           ///
       text(2.3 -1.9 "don't work", color(gs8) size(medium))                      ///
       text(2.55 `bB' "b{subscript:t} = E[{&epsilon}{superscript:w}|work] = `bB'", color(cranberry) size(medsmall) placement(e)) ///
       legend(off) graphregion(color(white)) name(B, replace)

graph combine A B, cols(2) xsize(7) ysize(4.4) graphregion(color(white))         ///
    note("Simulated draws, {&rho} = Cov({&epsilon}{superscript:r},{&epsilon}{superscript:w}) = 0.5." ///
         "Dashed line: participation frontier {&epsilon}{superscript:r} = ({&sigma}{superscript:w}/{&sigma}{superscript:r}){&epsilon}{superscript:w}. Women work below it (solid dots)." ///
         "Vertical line: mean wage draw among participants. Participation rate is 0.5 in both panels.", size(small))

graph export "mr_selection.pdf", replace
display "bA = `bA'  pA = `pA'   bB = `bB'  pB = `pB'"
