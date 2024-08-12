function nameFlds_zpp_latex = aSDG_zpp_name_to_latexName(nameFlds_zpp)
sz = length(nameFlds_zpp);
%nameFlds_zpp_latex = nameFlds_zpp;
ene = '\psi';
for i = 1:sz
    nm = nameFlds_zpp{i};
    nmLatex = nm;
    if (strcmp(nm, 'zpp_sn') == 1)
        nmLatex = 'n';
    elseif (strcmp(nm, 'zpp_sv') == 1)
        nmLatex = 't';
    elseif (strcmp(nm, 'zpp_eps_scalar') == 1)
        nmLatex = '\epsilon';
    elseif (strcmp(nm, 'zpp_sig_scalar') == 1)
        nmLatex = '\sigma';
    elseif (strcmp(nm, 'zpp_eps_voigt') == 1)
        nmLatex = '\epsilon_{xx}';
    elseif (strcmp(nm, 'zpp_sig_voigt') == 1)
        nmLatex = '\sigma_{xx}';
    elseif (strcmp(nm, 'zpp_y') == 1)
        nmLatex = 'Y';
    elseif (strcmp(nm, 'zpp_y') == 1)
        nmLatex = 'Y';
    elseif (strcmp(nm, 'zpp_psi_t') == 1)
        nmLatex = [ene, '_t'];
    elseif (strcmp(nm, 'zpp_psi_r') == 1)
        nmLatex = [ene, '_r'];
    elseif (strcmp(nm, 'zpp_psi_d') == 1)
        nmLatex = [ene, '_d'];
    elseif (strcmp(nm, 'zpp_psi_t_npsif') == 1)
        nmLatex = [ene, '_t/', ene, '_0'];
    elseif (strcmp(nm, 'zpp_psi_r_npsif') == 1)
        nmLatex = [ene, '_r/', ene, '_0'];
    elseif (strcmp(nm, 'zpp_psi_d_npsif') == 1)
        nmLatex = [ene, '_d/', ene, '_0'];
    elseif (strcmp(nm, 'zpp_d') == 1)
        nmLatex = 'D';
    elseif (strcmp(nm, 'zpp_ddot') == 1)
        nmLatex = '\dot{D}';
    elseif (strcmp(nm, 'zpp_ddot_ny') == 1)
        nmLatex = '\tilde{\tau}\dot{D}';
    elseif (strcmp(nm, 'zpp_eps_scalar_ny') == 1)
        nmLatex = '\epsilon/\tilde{\epsilon}';
    elseif (strcmp(nm, 'zpp_sig_scalar_ny') == 1)
        nmLatex = '\sigma/\tilde{\sigma}';
    elseif (strcmp(nm, 'zpp_dcracklength') == 1)
        nmLatex = 'L';
    elseif (strcmp(nm, 'zpp_stn_rel') == 1)
        nmLatex = '\epsilon_{\mathrm{rel}}';
    elseif (strcmp(nm, 'zpp_bcpow') == 1)
        nmLatex = 'E_{\mathrm{bc}}';
    elseif (strcmp(nm, 'zpp_fpow') == 1)
        nmLatex = 'E_{\mathrm{cr}}';
    elseif (strcmp(nm, 'zpp_fpow_indn') == 1)
        nmLatex = 'P_{\mathrm{cr}}^n';
    elseif (strcmp(nm, 'zpp_fpow_indt') == 1)
        nmLatex = 'P_{\mathrm{cr}}^t';
    end
    nameFlds_zpp_latex{i} = nmLatex;
end
