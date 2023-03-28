// 2023 Undergraduate Gradualation Disertation of Gong CHEN
// Major: Event Management
// Shenzhen Tourism College, Jinan University
// Tutor: Huiyue LIU, Vice Prof., Tourism Management Department
// e-mail: 2019054141@stu2019.jnu.edu.cn

// ---------------------------------Preparation---------------------------------
clear all
cd "D:\Users\cheng\Desktop\毕业论文\Data"
// ---------------------------------Data Filter---------------------------------
// Data Resource: CFPS, ISSS, Peking University
// Account: 2019054141@stu2019.jnu.edu.cn
// Thanks to Peking University and all the workers and volunteers

// Part 2012
*family 2012
//the data of family2012 don't have personal id, so we have to merge family data
//of 2014 to specify the personal id
use cfps2014famecon_201906,clear
keep fid14 fresp1pid
ren fid14 fid12

save 2012_pre, replace // storing personal id of financial representative

use cfps2012famecon_201906
sort fid12
merge 1:1 fid12 using 2012_pre
keep if _merge==3
drop _merge

keep fid12 provcd urban12 fresp1pid fp502 expense fincome1 fk1l
//	fid12       |  family id 2012
//	provcd      |  province id 2012
//	urban12     |  urban or not 2012
//	fresp1id    |  financial respondent id
//	fp502       |  family tourism expense
//	expense     |  family total expense
//	fincome1    |  family total income
//  fk1l        |  agricultural or migrant work
duplicates drop fid12, force
ren provcd prov
ren urban12 urban
ren fresp1pid pid
ren fp502 tour_exp
ren expense tota_exp
ren fincome1 tota_inc
ren fk1l agri_or_migr_work

*account mean value of family income
gen status_inc = .
egen mean_inc = mean(tota_inc)
replace status_inc = 1 if ///
tota_inc >= 0 & tota_inc <= 0.33 * mean_inc
replace status_inc = 2 if ///
tota_inc > 0.33 * mean_inc & tota_inc <= 0.66 * mean_inc
replace status_inc = 3 if ///
tota_inc > 0.66 * mean_inc & tota_inc <= mean_inc
replace status_inc = 4 if ///
tota_inc > mean_inc & tota_inc <= 1.33 * mean_inc
replace status_inc = 5 if ///
tota_inc > 1.33 * mean_inc
drop mean_inc

save family2012, replace

*adult 2012
use cfps2012adult_201906, clear
keep fid12 pid cfps2012_gender_best cfps2012_age qe104 qn8012 qp201 edu2012 ///
employ qn12012 job2012mn_occu

//	fid12       |  family id 2012
//	pid         |  personal id
//	cfps2012_gender_best |  gender
//	cfps2012_age|  age
//	qe104       |  marriage situation
//	qn8012      |  personal status judge
//	qp201       |  health situation
//	edu2012     |  education level
//  employ      |  employ situation
//	qn12012     |  satisifiction of family life
//	job2012mn_occu   |  classification of jobs
duplicates drop pid, force
ren cfps2012_gender_best gender
ren cfps2012_age age
ren qe104 marriage
ren qn8012 status_recog
ren qp201 health
ren edu2012 edu
ren qn12012 well_being
ren job2012mn_occu qg303code

//family age structure
gen value = 0
replace value = 1 if age <  0 
bys fid12: egen ifvalue = sum(value)

gen old=0
gen child1=0
gen labor1=0
replace old = 1 if age >= 60
replace child1 = 1 if age <= 14
replace labor1 = 1 if age >= 15 & age <= 59

bys fid12:egen old_n=sum(old)
bys fid12:egen child_n1=sum(child1)
bys fid12:egen labor_n1=sum(labor1)
drop old child1 labor1

save adult2012_temp, replace
// EPG classification of jobs is missing in CFPS2012, but classification of jobs
// exiusts. So we still can use the varible qg303code to get the EPG in CFPS2016
// by merging relative variable: qg303code_egp. 
// variable qg303codein CFPS2016.
use cfps2016adult_201906, clear
keep qg303code qg303code_egp
duplicates drop qg303code, force
save value, replace

use adult2012_temp, clear
merge m:1 qg303code using value
drop if _merge == 2
drop _merge
ren qg303code_egp egp
drop qg303code

save adult2012, replace

*child 2012
//family age structure
use cfps2012child_201906,clear
keep fid12 cfps2012_age
ren cfps2012_age age

gen value = 0
replace value = 1 if age <  0
bys fid12: egen ifvalue = sum(value)

gen child2 = 0
gen labor2 = 0
replace child2=1 if age <= 14
replace labor2=1 if age >= 15 & age <= 59

bys fid12:egen child_n2=sum(child2)
bys fid12:egen labor_n2=sum(labor2)
drop child2 labor2 age 

save child2012,replace

// Part 2014
*family 2014
use cfps2014famecon_201906, clear
keep fid14 provcd14 urban14 fresp1pid fp503 fexp finc fo1
//	fid14       |  family id 2014
//	provcd14    |  province id 2014
//	urban14     |  urban or not 2014
//	fresp1pid   |  financial respondent id
//	fp503       |  family tourism expense
//	fexp        |  family total expense
//	finc        |  family total income
//  fo1         |  agricultural or migrant work

duplicates drop fid14, force
ren provcd14 prov
ren urban14 urban
ren fresp1pid pid
ren fp503 tour_exp
ren fexp tota_exp
ren finc tota_inc
ren fo1 agri_or_migr_work

*account mean value of family income
gen status_inc = .
egen mean_inc = mean(tota_inc)
replace status_inc = 1 if ///
tota_inc >= 0 & tota_inc <= 0.33 * mean_inc
replace status_inc = 2 if ///
tota_inc > 0.33 * mean_inc & tota_inc <= 0.66 * mean_inc
replace status_inc = 3 if ///
tota_inc > 0.66 * mean_inc & tota_inc <= mean_inc
replace status_inc = 4 if ///
tota_inc > mean_inc & tota_inc <= 1.33 * mean_inc
replace status_inc = 5 if ///
tota_inc > 1.33 * mean_inc
drop mean_inc

save family2014, replace

*adult 2014
use cfps2014adult_201906, clear
keep fid14 pid cfps_gender cfps2014_age qea0 qn8012 qp201 cfps2014edu ///
employ2014 qn12012 qg303code
//	fid14       |  family id 2014
//	pid         |  personal id
//	cfps_gender |  gender
//	cfps2014_age|  age
//	qea0        |  marriage situation
//	qn8012      |  personal status judge
//	qp201       |  health situation
//	cfps2014edu |  education level
//  employ2014  |  employ situation
//	qn12012     |  satisifiction of family life
//	qg303code   |  classification of jobs
duplicates drop pid, force
ren cfps_gender gender
ren cfps2014_age age
ren qea0 marriage
ren qn8012 status_recog
ren qp201 health
ren cfps2014edu edu
ren employ2014 employ
ren qn12012 well_being

//family age structure
gen value = 0
replace value = 1 if age <  0 
bys fid14: egen ifvalue = sum(value)

gen old=0
gen child1=0
gen labor1=0
replace old = 1 if age >= 60
replace child1 = 1 if age <= 14
replace labor1 = 1 if age >= 15 & age <= 59

bys fid14:egen old_n=sum(old)
bys fid14:egen child_n1=sum(child1)
bys fid14:egen labor_n1=sum(labor1)
drop old child1 labor1

save adult2014_temp, replace
// EPG classification of jobs is missing in CFPS2014, but classification of jobs
// exiusts. So we still can use the varible qg303code to get the EPG in CFPS2016
// by merging relative variable: qg303code_egp. 
// variable qg303codein CFPS2016.
use cfps2016adult_201906, clear
keep qg303code qg303code_egp
duplicates drop qg303code, force
save value, replace

use adult2014_temp, clear
merge m:1 qg303code using value
drop if _merge == 2
drop _merge
ren qg303code_egp egp
drop qg303code

save adult2014, replace

*child 2014
//family age structure
use cfps2014child_201906,clear
keep fid14 cfps2014_age
ren cfps2014_age age

gen value = 0
replace value = 1 if age <  0
bys fid14: egen ifvalue = sum(value)

gen child2=0
gen labor2=0
replace child2=1 if age<=14
replace labor2=1 if age>=15&age<=59

bys fid14:egen child_n2=sum(child2)
bys fid14:egen labor_n2=sum(labor2)
drop child2 labor2 age 

save child2014,replace

// Part 2016
*family 2016
use cfps2016famecon_201807, clear
keep fid16 provcd16 urban16 resp1pid fp503 fexp finc fo1
//	fid16       |  family id 2016
//	provcd16    |  province id 2016
//	urban16     |  urban or not 2016
//	resp1pid    |  financial respondent id
//	fp503       |  family tourism expense
//	fexp        |  family total expense
//	finc        |  family total income
//  fo1         |  agricultural or migrant work
duplicates drop fid16, force
ren provcd16 prov
ren urban16 urban
ren resp1pid pid
ren fp503 tour_exp
ren fexp tota_exp
ren finc tota_inc
ren fo1 agri_or_migr_work

*account mean value of family income
gen status_inc = .
egen mean_inc = mean(tota_inc)
replace status_inc = 1 if ///
tota_inc >= 0 & tota_inc <= 0.33 * mean_inc
replace status_inc = 2 if ///
tota_inc > 0.33 * mean_inc & tota_inc <= 0.66 * mean_inc
replace status_inc = 3 if ///
tota_inc > 0.66 * mean_inc & tota_inc <= mean_inc
replace status_inc = 4 if ///
tota_inc > mean_inc & tota_inc <= 1.33 * mean_inc
replace status_inc = 5 if ///
tota_inc > 1.33 * mean_inc
drop mean_inc

save family2016, replace

*adult 2016
use cfps2016adult_201906, clear
keep fid16 pid cfps_gender cfps_age qea0 qn8012 qp201 cfps2016edu employ ///
qn12012 qg303code_egp
//	fid16       |  family id 2016
//	pid         |  personal id
//	cfps_gender |  gender
//	cfps_age    |  age
//	qea0        |  marriage situation
//	qn8012      |  personal status judge
//	qp201       |  health situation
//	cfps2016edu |  education level
//  employ      |  employ situation
//	qn12012     |  satisifiction of family life
// qg303code_egp|  EPG classification of jobs
duplicates drop pid, force
ren cfps_gender gender
ren cfps_age age
ren qea0 marriage
ren qn8012 status_recog
ren qp201 health
ren cfps2016edu edu
ren qn12012 well_being
ren qg303code_egp egp

//family age structure
gen value = 0
replace value = 1 if age <  0 
bys fid16: egen ifvalue = sum(value)

gen old=0
gen child1=0
gen labor1=0
replace old = 1 if age >= 60
replace child1 = 1 if age <= 14
replace labor1 = 1 if age >= 15 & age <= 59

bys fid16:egen old_n=sum(old)
bys fid16:egen child_n1=sum(child1)
bys fid16:egen labor_n1=sum(labor1)
drop old child1 labor1

save adult2016, replace

*child 2016
//family age structure
use cfps2016child_201906,clear
keep fid16 cfps_age
ren cfps_age age

gen value = 0
replace value = 1 if age <  0
bys fid16: egen ifvalue = sum(value)

gen child2=0
gen labor2=0
replace child2=1 if age<=14
replace labor2=1 if age>=15&age<=59

bys fid16:egen child_n2=sum(child2)
bys fid16:egen labor_n2=sum(labor2)
drop child2 labor2 age

save child2016,replace

// Part 2018
*family 2018
use cfps2018famecon_202101, clear
keep fid18 provcd18 urban18 resp1pid fp503 fexp finc fo1
//	fid18       |  family id 2018
//	provcd18    |  province id 2018
//	urban18     |  urban or not 2018
//	fresp1pid   |  financial respondent id
//	fp503       |  family tourism expense
//	fexp        |  family total expense
//	finc        |  family total income
//  fo1         |  agricultural or migrant work

duplicates drop fid18, force
ren provcd18 prov
ren urban18 urban
ren resp1pid pid
ren fp503 tour_exp
ren fexp tota_exp
ren finc tota_inc
ren fo1 agri_or_migr_work

*account mean value of family income
gen status_inc = .
egen mean_inc = mean(tota_inc)
replace status_inc = 1 if ///
tota_inc >= 0 & tota_inc <= 0.33 * mean_inc
replace status_inc = 2 if ///
tota_inc > 0.33 * mean_inc & tota_inc <= 0.66 * mean_inc
replace status_inc = 3 if ///
tota_inc > 0.66 * mean_inc & tota_inc <= mean_inc
replace status_inc = 4 if ///
tota_inc > mean_inc & tota_inc <= 1.33 * mean_inc
replace status_inc = 5 if ///
tota_inc > 1.33 * mean_inc
drop mean_inc

save family2018, replace

*adult 2018
use cfps2018person_202012, clear
keep fid18 pid gender age qea0 qn8012 qp201 cfps2018edu employ qn12012 ///
qg303code_egp
//	fid18       |  family id 2018
//	pid         |  personal id
//	gender      |  gender
//	age         |  age
//	qea0        |  marriage situation
//	qn8012      |  personal status judge
//	qp201       |  health situation
//	cfps2018edu |  education level
//  employ      |  employ situation
//	qn12012     |  satisfaction of life
// qg303code_egp|  EPG classification of jobs
duplicates drop pid, force
ren qea0 marriage
ren qn8012 status_recog
ren qp201 health
ren cfps2018edu edu
ren qn12012 well_being
ren qg303code_egp egp

//family age structure
gen value = 0
replace value = 1 if age <  0 
bys fid18: egen ifvalue = sum(value)

gen old=0
gen child1=0
gen labor1=0
replace old = 1 if age >= 60
replace child1 = 1 if age <= 14
replace labor1 = 1 if age >= 15 & age <= 59

bys fid18:egen old_n=sum(old)
bys fid18:egen child_n1=sum(child1)
bys fid18:egen labor_n1=sum(labor1)
drop old child1 labor1

save adult2018, replace

*child 2018
//family age structure
use cfps2018childproxy_202012,clear
keep fid18 age

gen value = 0
replace value = 1 if age <  0
bys fid18: egen ifvalue = sum(value)

gen child2=0
gen labor2=0
replace child2=1 if age<=14
replace labor2=1 if age>=15&age<=59

bys fid18:egen child_n2=sum(child2)
bys fid18:egen labor_n2=sum(labor2)
drop child2 labor2 age

save child2018,replace

// Part 2020
* According to the information from CFPS,PKU (http://www.isss.pku.edu.cn/cfps/), 
* family economic data will be released at Spring, 2023. We still keep the part 
* to wait for the new data.
// ---------------------------------Data Merge----------------------------------
// Part 2012
use family2012,clear
duplicates drop pid,force
sort fid12
merge 1:1 pid using adult2012
keep if _merge==3
drop _merge

sort fid12
merge 1:m fid12 using child2012
drop if _merge==2
drop _merge
duplicates drop fid12,force

foreach var in child_n2 labor_n2{
replace `var'=0 if `var'==.
}

gen child_n=child_n1+child_n2
gen labor_n=labor_n1+labor_n2
drop child_n1 labor_n1 child_n2 labor_n2

gen year=2012
ren fid12 fid

*Delete the family missing age and population data
drop if ifvalue == 1
drop ifvalue 
drop value

save 2012, replace

// Part 2014
use family2014,clear
duplicates drop pid,force
sort fid14
merge 1:1 pid using adult2014
keep if _merge==3
drop _merge

sort fid14
merge 1:m fid14 using child2014
drop if _merge==2
drop _merge
duplicates drop fid14,force

foreach var in child_n2 labor_n2{
replace `var'=0 if `var'==.
}

gen child_n=child_n1+child_n2
gen labor_n=labor_n1+labor_n2
drop child_n1 labor_n1 child_n2 labor_n2

gen year=2014
ren fid14 fid

*Delete the family missing age and population data
drop if ifvalue == 1
drop ifvalue 
drop value

save 2014, replace

// Part 2016
use family2016,clear
duplicates drop pid,force
sort fid16
merge 1:1 pid using adult2016
keep if _merge==3
drop _merge

sort fid16
merge 1:m fid16 using child2016
drop if _merge==2
drop _merge
duplicates drop fid16,force

foreach var in child_n2 labor_n2{
replace `var'=0 if `var'==.
}

gen child_n=child_n1+child_n2
gen labor_n=labor_n1+labor_n2
drop child_n1 labor_n1 child_n2 labor_n2

gen year=2016
ren fid16 fid

*Delete the family missing age and population data
drop if ifvalue == 1
drop ifvalue 
drop value

save 2016, replace

// Part 2018
use family2018,clear
duplicates drop pid,force
sort fid18
merge 1:1 pid using adult2018
keep if _merge==3
drop _merge

sort fid18
merge 1:m fid18 using child2018
drop if _merge==2
drop _merge
duplicates drop fid18,force

foreach var in child_n2 labor_n2{
replace `var'=0 if `var'==.
}

gen child_n=child_n1+child_n2
gen labor_n=labor_n1+labor_n2
drop child_n1 labor_n1 child_n2 labor_n2

gen year=2018
ren fid18 fid

*Delete the family missing age and population data
drop if ifvalue == 1
drop ifvalue 
drop value

save 2018, replace

// Part 2020
* According to the information from CFPS,PKU (http://www.isss.pku.edu.cn/cfps/), 
* family economic data will be released at Spring, 2023. We still keep the part 
* to wait for the new data.

// Panel Construct
use 2012.dta,clear
append using 2014.dta 2016.dta 2018.dta
order fid year
sort fid year
duplicates drop fid year, force
xtset fid year
save unbalance_paneldata, replace
// Panel Balance
bys fid: egen num = count(fid)
keep if num == 4
drop num
xtset fid year
save balance_paneldata, replace
// ---------------------------------Data Clean----------------------------------
use balance_paneldata, clear
// Value adjustment
foreach var in tour_exp marriage tota_inc tota_exp {
	gen value = 0
	replace value = 1 if `var' <0
	bys fid: egen ifvalue = sum(value)
	drop if ifvalue > 0
	drop ifvalue
	drop value
}

replace employ = 0 if employ == 3 |employ < 0 
replace agri_or_migr_work = 0 if agri_or_migr_work == 5 // value 5 same as 0
replace urban = . if urban < 0 // urban data cannot judge
replace status_recog = . if status_recog > 5
// Vacancy value fill

replace edu = . if edu == 9 //means "unnacessary to accept education", delete it
//to avoid misjudging.

foreach var in status_recog edu tour_exp well_being health {
  egen aver = mean(`var')
  replace `var' = aver if `var' == . | `var'  < 0
  drop aver
}

// clean currency data
gen lntour_exp = ln(tour_exp + 1)
gen lntota_inc = ln(tota_inc + 1)
gen lntota_exp = ln(tota_exp + 1)

save balance_paneldata, replace
kdensity tour_exp

// -----------------------------Varibles Construct------------------------------

// Generate tourism ratio of expense
gen tour_rat_ex = tour_exp / tota_exp
*tourism ratio adjustment
gen value = 0
replace value = 1 if tour_rat > 1
bys fid: egen ifvalue = sum(value)
drop if ifvalue > 0
drop ifvalue
drop value
kdensity tour_rat_ex

// Generate tourism ratio of income
gen tour_rat_in = tour_exp/tota_inc
*tourism ratio adjustment
gen value = 0
replace value = 1 if tour_rat_in>1
bys fid: egen ifvalue = sum(value)
drop if ifvalue > 0
drop ifvalue
drop value
kdensity tour_rat_in

// Health value reserve
forvalues i = 1/5{
replace health = `i'`i'`i'`i'   if health == `i'
}

forvalues i = 1/5{
replace health = 6-`i'   if health == `i'`i'`i'`i'
}
// Dependency ratio
// Attention: 
// Some family don't have labor force, so the cauculation of dependency rate may
// cause the miss of value. To deal with the problem and show the actuall ratio,
// we plus value 0.1 to every family labor number.
gen Depend_rat = (child_n + old_n) / (labor_n + 0.1)
gen Depend_rat_c = child_n / (labor_n + 0.1)
gen Depend_rat_o = old_n / (labor_n + 0.1)

// Family scale
gen pop = child_n + labor_n + old_n

save temp, replace

// Objective Status Score
// Part income finished
// Part jobs
gen status_job = .
replace status_job = 1 if egp == 9 | egp == 11
replace status_job = 2 if egp == 7 | egp == 8 | egp == 10
replace status_job = 3 if egp >= 3 & egp <= 6
replace status_job = 4 if egp == 2
replace status_job = 5 if egp == 1
egen mean_job = mean(status_job)
replace status_job = mean_job if status_job == .
drop mean_job
// Part edu
gen status_edu = .
//Because we take mean value as vaccant edu value, we use round function to give
//education status score. 
replace status_edu = 1 if round(edu) == 1
replace status_edu = 2 if round(edu) == 2 | edu == 3
replace status_edu = 3 if round(edu) == 4
replace status_edu = 4 if round(edu) == 5 | edu == 6
replace status_edu = 5 if round(edu) == 7 | edu == 8
egen mean_edu = mean(status_edu)
replace status_edu = mean_edu if status_edu == .
drop mean_edu

gen status_obj = (status_inc + status_job + status_edu) / 3
gen status_offset = status_recog - status_obj

// -----------------------------Instrument variables----------------------------

// Instrument variables: pm25_pop pm25_geo 
// Data Resource: Public data from: 
// Atmospheric Composition Analysis Group, Washington University in St.Louis
// website: https://sites.wustl.edu/acag/datasets/surface-pm2-5/#V5.GL.03
// Thanks to Washington University in St.Louis and all the workers behind

// Instrument variables: express
// Data Resource: CSMAR (https://www.gtarsc.com), Shenzhen
// CSMAR Data Account Supported by Library of Jinan University
// Download IP: 14.23.56.43

// You can find the data in Instrument_Variables.xlsx, for convenience, we edit 
// it as a stata file Instrument_Variables.dta

merge m:m prov year using Instrument_Variables
keep if _merge==3
drop _merge

drop if fid == .
*summary
sum
save data_final, replace
// ------------------------------Variables Filter-------------------------------
use data_final,clear
global primary = "fid year prov pid agri_or_migr_work urban age gender"
global primary = "$primary marriage health edu employ status_recog well_being"
global primary = "$primary lntour_exp lntota_inc lntota_exp tour_rat_ex"
global primary = "$primary tour_rat_in Depend_rat Depend_rat_c Depend_rat_o pop"
global primary = "$primary status_obj status_offset pm25_pop pm25_geo express"

keep $primary

label var fid "家庭编码"
label var year "调查年份"
label var prov "省份"
label var agri_or_migr_work "是否外出务工"
label var urban "城乡"				
label var age "户主年龄"
label var gender "户主性别"
label var marriage "户主婚姻状况"
label var health "户主健康状况"
label var edu "户主学历状况"
label var employ "户主工作情况"
label var status_recog "主观地位评分"
label var well_being "幸福感"
label var lntour_exp "旅游支出对数"
label var lntota_inc "总收入对数"
label var lntota_exp "总支出对数"
label var tour_rat_ex "旅游支出占总支出"
label var tour_rat_in "旅游指出占总收入"
label var Depend_rat "总抚养比"
label var Depend_rat_c "孩童抚养比"
label var Depend_rat_o "老人抚养比"
label var pop "家庭规模"
label var status_obj "客观身份地位"
label var status_offset "阶层认同偏移"
label var pm25_pop "人均pm2.5"
label var pm25_geo "地均pm2.5"
label var express "快递运输量"
save variables, replace

// -----------------------------Basic Regression--------------------------------

* Preparation
use variables, clear
sum
sum2docx fid year prov pid agri_or_migr_work urban age gender marriage health ///
edu employ status_recog well_being lntour_exp lntota_inc lntota_exp ///
tour_rat_ex tour_rat_in Depend_rat Depend_rat_c Depend_rat_o pop status_obj ///
status_offset pm25_pop pm25_geo using draft.docx, ///
  replace stats(N mean(%9.4f) sd(%9.4f) min(%9.0f) max(%9.0f)) ///
  landscape title("数据描述性统计表") font("times new roman",12,"black") ///
  note("this is auto's Summary Statistics") pagesize(A4)

*Strongly banlanced
tsset fid year
xtdes

global Rcog "status_recog"
global Ctrl "lntota_inc Depend_rat pop age health edu"
xtreg lntour_exp well_being $Rcog $Ctrl, fe
xtreg lntour_exp well_being $Rcog $Ctrl, re
xttest0

* hausman test
qui xtreg lntour_exp well_being $Rcog $Ctrl, fe
est store fe
qui xtreg lntour_exp well_being $Rcog $Ctrl, re
est store re

hausman fe re

* Time dummy variables for controling time effect
tab year ,gen(dumt)
drop dumt1

*Fix-effect model and control time effect
xtreg lntour_exp well_being $Rcog $Ctrl dumt*, fe

* This part we found that the coefficient of the  'well_being'  turn to nagetive 
* after we use the instrumental variable to, too. But the fact is the conclusion 
* may differ from the researches now, and also consider the fact that well_being
* do promote the tourism expene, we assume the relation between 'well_being' and 
* toursim expense is a kind of inverted- u relation. Thus, we need add quadratic
* term in our model.
gen well_being2 = well_being^2
label var well_being2 "幸福感平方项"
xtreg lntour_exp well_being2 well_being $Rcog $Ctrl dumt*, fe r
//xtreg lntour_exp well_being status_offset $Rcog $Ctrl dumt*, fe

// --------------------Panel Two Stage Least Square & GMM-----------------------

* Panel 2sls
gen pm25 = ln(pm25_geo)
label var pm25 "地均pm2.5对数"
*Fix-effect Two Stage Least Square
xtivreg2 lntour_exp (well_being = pm25) $Rcog $Ctrl dumt*, fe

* This part we found that the coefficient of the well_being turn to nagetive 
* after we using the instrumental variable. For farther research, we use GMM
* to try to get a robust conclusion.

*add express as a instrument and change estimation path to GMM
xtivreg2 tour_rat_ex (well_being = pm25 express) $Rcog $Ctrl dumt*, fe gmm

// ----------------------------Double Hurdle Model------------------------------

* Attention: it takes a long time in this part.
// please do 'search xtdhreg, all' to get the soft package
* Double herdle model
xtdhreg lntour_exp well_being $Rcog $Ctrl dumt*, ///
hd(well_being status_recog Depend_rat) difficult

* add well_being2
xtdhreg lntour_exp well_being $Rcog $Ctrl dumt*, ///
hd(well_being well_being2 status_recog) difficult

// please do 'search bootdhreg, all' to get the soft package
* change estimation path to bootstrap
* Attention: it takes a long time
bootdhreg lntour_exp well_being $Rcog $Ctrl dumt*, ///
hd(well_being status_recog Depend_rat)
bootdhreg lntour_exp well_being $Rcog $Ctrl dumt*, ///
hd(well_being well_being2 status_recog Depend_rat)

// --------------------------Fixed Effect Logit Model---------------------------

// please do 'search feologit, all' to get the soft package
gen well_being1 = int(well_being)
gen tour_des = 0
replace tour_des = 1 if lntour_exp > 0
label var well_being1 "幸福感整数值"
label var tour_des "家庭旅游决策"

*BUC estimator
feologit well_being1 lntour_exp $Rcog $Ctrl dumt*
feologit well_being1 tour_des $Rcog $Ctrl dumt*
* Odds rate
feologit, or nolog
* Marginal effect
logitmarg
*BUC-t estimator
feologit well_being1 lntour_exp $Rcog $Ctrl dumt*, threshold keep
* Odds
feologit, or nolog

*test whether the cuts range according to individual
*generate interact
foreach i of var lntour_exp $Rcog $Ctrl dumt* {
     qui gen tau_`i' = `i'*(bucsample==0)
  }
global interact = "tau_lntour_exp tau_status_recog tau_lntota_inc"
global interact = "$interact tau_Depend_rat tau_pop tau_age tau_health tau_edu"
global interact = "$interact tau_dumt2 tau_dumt3 tau_dumt4 "

clogit dkdepvar lntour_exp $Rcog $Ctrl dumt* $interact i.dkthreshold, ///
group(clonegroup) cluster(fid) nolog

* test: H0: the cuts range constant to individual
test $interact
* p value = 0.0000

// -----------------------------Sgmediation test--------------------------------
use variables, clear
bootstrap r(ind_eff) r(dir_eff), reps(500): ///
sgmediation lntour_exp, mv(status_recog) iv(well_being) cv($Ctrl)
estat bootstrap, percentile bc

bootstrap r(ind_eff) r(dir_eff), reps(500): ///
sgmediation lntour_exp, mv(status_offset) iv(well_being) cv($Ctrl)
estat bootstrap, percentile bc

// --------------------------Disscuss on Status_offset--------------------------
tsset fid year
xtdes
tab year, gen(dumt)
drop dumt1
global Rcog "status_recog status_offset "
global Ctrl "lntota_inc Depend_rat pop age health edu"

xtreg lntour_exp well_being well_being2 $Rcog $Ctrl, fe
xtivreg2 lntour_exp (well_being = pm25) $Rcog $Ctrl dumt*, fe
xtdhreg lntour_exp well_being $Rcog $Ctrl dumt*, ///
hd(well_being status_offset Depend_rat) difficult

gen tour_des = 0
replace tour_des = 1 if lntour_exp > 0
gen well_being1 = int(well_being)
feologit well_being1 lntour_exp $Rcog $Ctrl dumt*
feologit well_being1 tour_des $Rcog $Ctrl dumt*
* Odds rate
feologit, or nolog
* Marginal effect
logitmarg
*BUC-t estimator
feologit well_being1 lntour_exp $Rcog $Ctrl dumt*, threshold keep
* Odds
feologit, or nolog
// ----------------------------Heterogeneity test-------------------------------
use variables, clear
* Preparation
tsset fid year
xtdes
tab year, gen(dumt)
drop dumt1
gen well_being2 = well_being^2
global Rcog "status_recog status_offset "
global Ctrl "lntota_inc Depend_rat pop age health edu"
global Clas "urban agri_or_migr_work marriage gender employ"

ommit

// ----------------------------Heterogeneity test-------------------------------
* codes sum from https://www.lianxh.cn, thanks to the '连享会' and Doc.Lian
