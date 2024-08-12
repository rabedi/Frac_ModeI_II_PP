function nameFlds_zpr_latex = aSDG_zpr_name_to_latexName(nameFlds_zpr)
sz = length(nameFlds_zpr);
ene = '\psi';
for i = 1:sz
    nm = nameFlds_zpr{i};
    nmLatex = nm;
    
    if (strcmp(nm, 'zpp_sn') == 1)
        nmLatex = 't';
    elseif (strcmp(nm, 'zpr_stssh_xx') == 1)
        nmLatex = '\sigma_{xx}';
    elseif (strcmp(nm, 'zpr_stssh_yy') == 1)
        nmLatex = '\sigma_{yy}';
	elseif (strcmp(nm, 'zpr_stssh_xy') == 1)
        nmLatex = '\sigma_{xy}';
	elseif (strcmp(nm, 'zpr_stnst_xx') == 1)
        nmLatex = '\epsilon_{xx}';
    elseif (strcmp(nm, 'zpr_stnst_yy') == 1)
        nmLatex = '\epsilon_{yy}';
    elseif (strcmp(nm, 'zpr_stnst_xy') == 1)
        nmLatex = '\epsilon_{xy}';
    elseif (strcmp(nm, 'zpr_stssh_xx_ny') == 1)
        nmLatex = '\sigma_{xx}/\tilde{\sigma}';
    elseif (strcmp(nm, 'zpr_stssh_yy_ny') == 1)
        nmLatex = '\sigma_{yy}/\tilde{\sigma}';
    elseif (strcmp(nm, 'zpr_stssh_xy_ny') == 1)
        nmLatex = '\sigma_{xy}/\tilde{\sigma}';
    elseif (strcmp(nm, 'zpr_stnst_xx_ny') == 1)
        nmLatex = '\epsilon_{xx}/\tilde{\epsilon}';
    elseif (strcmp(nm, 'zpr_stnst_yy_ny') == 1)
        nmLatex = '\epsilon_{yy}/\tilde{\epsilon}';
    elseif (strcmp(nm, 'zpr_stnst_xy_ny') == 1)
        nmLatex = '\epsilon_{xy}/\tilde{\epsilon}';
    elseif (strcmp(nm, 'zpr_dynerr_rel') == 1)
        nmLatex = 'E_{rdyn}';
    elseif (strcmp(nm, 'zpr_dynerr_ind0') == 1)
        nmLatex = '|E_{dyn}|';
    elseif (strcmp(nm, 'zpr_dynerr_ind1') == 1)
        nmLatex = 'E_{dyn_x}';
    elseif (strcmp(nm, 'zpr_dynerr_ind2') == 1)
        nmLatex = 'E_{dyn_y}';
    elseif (strcmp(nm, 'zpr_fpow_rel') == 1)
        nmLatex = 'P_t/P';
    elseif (strcmp(nm, 'zpr_fraca_scalar_d_mean') == 1)
        nmLatex = '{E}(D)';
    elseif (strcmp(nm, 'zpr_fraca_scalar_d_max') == 1)
        nmLatex = '\mathrm{max}(D)';
    elseif (strcmp(nm, 'zpr_fraca_scalar_cr_mean') == 1)
        nmLatex = '{E}(\eta)';
    elseif (strcmp(nm, 'zpr_fraca_scalar_cr_max') == 1)
        nmLatex = '\mathrm{max}(\eta)';
    elseif (strcmp(nm, 'zpr_fraca_scalar_str_mean') == 1)
        nmLatex = '{E}(\gamma)';
    elseif (strcmp(nm, 'zpr_fraca_scalar_str_max') == 1)
        nmLatex = '\mathrm{max}(\gamma)';
    elseif (strcmp(nm, 'zpr_fraca_scalar_sa_mean') == 1)
        nmLatex = '{E}(a_\mathrm{S})';
    elseif (strcmp(nm, 'zpr_fraca_scalar_sa_max') == 1)
        nmLatex = '\mathrm{max}(a_\mathrm{S})';
    elseif (strcmp(nm, 'zpr_fraca_scalar_sla_mean') == 1)
        nmLatex = '{E}(a_\mathrm{SL})';
    elseif (strcmp(nm, 'zpr_fraca_scalar_sla_max') == 1)
        nmLatex = '\mathrm{max}(a_\mathrm{SL})';
    elseif (strcmp(nm, 'zpr_fraca_scalar_sta_mean') == 1)
        nmLatex = '{E}(a_\mathrm{ST})';
    elseif (strcmp(nm, 'zpr_fraca_scalar_sta_max') == 1)
        nmLatex = '\mathrm{max}(a_\mathrm{ST})';
    elseif (strcmp(nm, 'zpr_fraca_scalar_d_len_revind0') == 1)
        nmLatex = 'l_{D_{\mathrm{max}}}';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_len_mean') == 1)
        nmLatex = '{E}(\theta)';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_len_r') == 1)
        nmLatex = 'r_\theta';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_len_sdiv') == 1)
        nmLatex = '\mathrm{\sigma}_\theta';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_len_sdiv') == 1)
        nmLatex = '\mathrm{\sigma}_\theta';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_sym_len_mean') == 1)
        nmLatex = '{E}^s(\theta)';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_sym_len_r') == 1)
        nmLatex = 'r^s_\theta';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_sym_len_sdiv') == 1)
        nmLatex = '\mathrm{\sigma}^s_\theta';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_len_mean') == 1)
        nmLatex = '{E}(\theta)';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_len_r') == 1)
        nmLatex = 'r_\theta';
    elseif (strcmp(nm, 'zpr_fraca_angle_stat_len_sdiv') == 1)
        nmLatex = '\mathrm{\sigma}_\theta';
    elseif (strcmp(nm, 'zpr_dcracklength') == 1)
        nmLatex = 'l_\mathrm{tot}';
    elseif (strcmp(nm, 'zpr_dcracklength') == 1)
        nmLatex = 'l_\mathrm{tot}';
    elseif (strcmp(nm, 'zpr_stn_rel') == 1)
        nmLatex = '\bar{\epsilon}_{cr}/\bar{\epsilon}';
    elseif (strcmp(nm, 'zpr_dcount') == 1)
        nmLatex = 'N_{cr}';
    elseif (strcmp(nm, 'zpr_bcpow') == 1)
        nmLatex = 'P_{\mathrm{BC}}';
    elseif (strcmp(nm, 'zpr_fpow') == 1)
        nmLatex = 'P_{cr}';
    elseif (strcmp(nm, 'zpr_fpow_indn') == 1)
        nmLatex = 'P_{cr}^n';
    elseif (strcmp(nm, 'zpr_fpow_indt') == 1)
        nmLatex = 'P_{cr}^t';
    end
    nameFlds_zpr_latex{i} = nmLatex;
end
