%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Entire domain

%%%%%%%%%%%% indices
_ny			-> values are normalized by corresponding scale
xx, xy, yx, yy (or 11, 12, 21, 22) -> mapped to 11, ...
indn, inds (or indt) -> 1, 2
ind_number -> number 

OR after 
scalar_number -> number 
or 
scalar_name name in {d, cr, str, ba, sa, ca, sta, sla, pf}

%%%%%%%%%%%%


time			-> domain
dcracklength		-> total crack length
dcount			-> number of crack segments
dcntpt			-> number of crack segment points processed
dynerr			-> error in dynamics (rhoa, rhob contibution)
				dynerr		vector
				dynerr_ind0	abs value	
				dynerr_ind1	component1
				dynerr_ind2	component2
				dynerr_rel	relative value (nondimentional)
stn_rel			-> ratio_crackStrain2totalStrain (ratio of crack based strain to total strain): it's a measure of damage

bcpow			-> power from BCs
				bcpow		sum of power from BCs
				bcpow_indn	sum of power from normal type BC
				bcpow_indt (s)	sum of power from tangential type BC
				bcpow_rel	tangnetial / total BC power 
					_ny normalize it by (sc * vc)				

fpow			-> power from fracture surfaces
				fpow		sum of power from fracture
				fpow_indn	sum of power from normal type fracture
				fpow_indt (s)	sum of power from tangential type fracture
				fpow_rel	tangnetial / total fracture power 
					_ny normalize it by (sc * vc)
		

e.g. 
fpow_ny 	fracture power normalized by (sc * vc)
fpow_rel	relative shear to total power

%%%%%%%%%%%% 
stress and strain
(s/r) s: symmetrized; r: raw (e.g. for strain = grad u)
_ny: normalized values are returned
_pu: for stress, strain returns load, displacement

stress
sts(s/r)(h/s)(component = xx, xy, yx, yy or no entry -> whole matrix)(_nyL: optional -> nondimensional stress / sigmaC is returned)
h: homogenized rigorously, h our previous haphazard way

strain
stn(s/r)(t/c/b)(component = xx, xy, yx, yy or no entry -> whole matrix)(_nyL: optional -> nondimensional stress / (sigmaC/E) is returned)
t: total, c: crack, b: bulk

e.g. 
stssh_xx		component xx of stress tensor (sym + correctly homogenized)
stssh_yy_ny		normalized by sigmaC of comp of yy of same matrix
stnst			total strain tensor
stnsc			crack contribution to strain tensor
stnsb_ny		bulk contribution to strain tensor (normalized)
stnst_xx_pu		displacement in x direction (Delta x) total
stssh_xx_pu		Force x 


%%%%%%%%%%%%%%%%%%%%%%%% 
BC specific
bc2... prints stuff for BC 2
bca... prints contribution from all BCs (e.g. member: domainBCEdgesCombined)
see pp_energyDispBoundary for specific options for BC

e.g.
bca_int_sn	total force error vector in the whole domain = int_Domain (rhoa - rhob) dV - as a vector
bca_int_sn_ind0	total force error magnitude
bc2_int_snox	integral of s.n * x over BC 2

%%%%%%%%%%%%%%%%%%%%%%%% 
fracture specific
frac7... 	prints stuff for fracture face flags 7
fraca_...	collection of all fractures
fraca3_...	collection of all fractures in bin number 3 grouped by angle
for details of bc, refer to pp_energyDispInterior

e.g. 
fraca_scalar_d_mean		mean of damage over the whole domain (on all crack surfaces)
fraca_scalar_sa_max		max of separaration absolute for all cracks

fraca10_scalar_ca_rel_revind_0	in angle group 10 (here corresponding to angles 85-95 (#angle 18)), what persentage of cracks have ca greater than last breakpoint of values from 0 to 1 (e.g. .9 here, with step size 0.1)
fraca10_scalar_sa_len_ind_3	in angle group 10 (here corresponding to angles 85-95 (#angle 18)), what length of cracks have sa greater than the 3rd breakpoint (.3)

fraca_angle_stat_len_mean	mean angle for all cracks, by angle with length weight in computing mean
fraca_angle_stat_len_r		same as above but r is given
frac8_angle_len_rel		PDF of crack angle for fracture surface 8
frac8_angle_count_tot		count of cracks distributions for fracture surface 8 (e.g. how many count of cracks fall into each crack angle range bin)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pp_stat_crackDir

mean    	: mean angle (degree)
meanrad 	: mean angle radian)
sdiv    	: standard devision
_r		: r


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pp_energyDispBoundary
int_xn		: integral of x * n  used for computing area
int_sn		: in statics it's zero; in dynamics it's equal to integral of rho (a - b) [total - mean of (a - b)]
int_snox	: integral of s.n * x : used for computing stress)
int_un		: integral of u * n : used for computing grad u (and strain)
int_vsn	/ pow  / dissDot : integral for power term
		 indices <= (total), 0, 1 normal and tangential; having 
		 rel  			in the word -> power1 / totalpower
ind0 -> norm returned

examples

int_snox_xx = int_snox(1, 1)
int_vsn_indn = normal power 
int_vsn_indt = tangential power 
int_vsn = total power 
int_vsn_rel = relative shear to total power
int_snox_ind0	norm of int_snox_xx

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pp_energyDispInterior

%%%%%%%%%%%%%%%%%%%%%%%% Miscelaneous
totallength 	: total crack length
count		: crack counter

Integrals: similar to pp_energyDispBoundary
has int in name
%%%%%%%%%%%%%%%%%%%%%%%%
int_... 

scalar (has scalar in name)
%%%%%%%%%%%%%%%%%%%%%%%%
Group of scalars:
Two (three) things need to be specificed
A. fld index: for example ind_cr ind_d, ind_ca, ...
B. type of computation:
	int: integral of field on crack surfaces
	mean: min value on crack surfaces
	min: min value on crack surfaces
	max: max value on crack surfaces
	(*) rel/pdf/per: rel length of cracks with value larger than (see (*))
	(*) len (or none of the above): length of cracks with value larger than (see (*))

C. Only for options (*) below: what total or relative length of cracks have value larger than specified value

in this class there is step4ScalarCDFsVals
inside which are steps for breaking crack segments (e.g. [0.1 0.2 0.7 0.9 0.99])
ind1 refers to position in this vector

if ind1 <= 0 we look from the end of vector (e.g. ind1 = 0 -> values larger than 0.99 are taken)
if ind1 >  0 values are taken from the beginning of the vector


angle (crack angle: has angle in name)
%%%%%%%%%%%%%%%%%%%%%%%%	
Groups of names in str

A. count vs length
   default: length -> count must be provided
	given values are based on crack count rather than length (e.g. % of # cracks with angles between 30-40 degree, rather than % of crack length ....)
	if count is not provided length (default) is used

B. accumulative vs relative
   default: accumulative	-> for relative rel must be provided
	if 		rel / per / pdf 
	      given: percent of cracks within an angle is given, otherwise total crack count / length (option A) is provided


C. stat (brief summary) vs. total population
   default:   total population is used -> for summary (mean, r, sdiv) -> stat must be in the name

   within group w/o stat -> if ind1 > 0 -> single value is given: otherwise the entire population is returned

   within group stat -> 
			stat1. additional options are (mean, meanrad, r_, sdiv): see pp_stat_crackDir
			stat2. sym : if sym is added to the name: stat is computed for symmetric crack population w.r.t. XY axes (e.g. angles +/- 30, +/- 150 are the same) -> good for compressive fracture
	
	
Examples:

int_vsn_ind1 		-> int_vsn(1): normal power
totallength		-> total crack length
count			-> crack count

%%%%% scalars
scalar_d_int		-> integral of damage (d) on crack surfaces
scalar_cr_min		-> minimum cr value on crack surfaces
scalar_sta_mean		-> mean of sta (stick absolute) on crack surfaces
scalar_sta_rel_revind0	-> what percentage (rel) of cracks have sta larger than the maximum break point (revind -> nonpositive index is given)
scalar_sta_len_ind3	-> what total length (len) of cracks have sta larger than the break point number 3



%%%%% crack angles
%% population
% below len or tot can be omitted as they are default values
% these return total crack popultation angluar distribution based on 
angle_count_tot		-> total crack count
angle_len_tot		-> total length
angle_count_rel		-> crack count relative (PDF)
angle_len_rel		-> length relative (PDF)

if _ind5 is added in the name from the population, component number 5 is taken

%% stat summary
angle_stat_count_mean	 -> mean of crack angle computed using crack count
angle_stat_len_r	 -> r for crack angle with crack length angle incorporated
angle_stat_sym_len_sdiv  -> XY sym, length used, standard deviation is given



