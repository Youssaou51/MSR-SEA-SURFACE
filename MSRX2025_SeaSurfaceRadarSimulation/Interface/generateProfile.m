function data = generateProfile(u10, l_s, n_s, k, fetch_m, prec, isoMdl)

    switch isoMdl
        case 'Elfouhaily'
            [H, X_h, ~, ~, ~, ~, ~] = f_GeneSurfMer2D_ElfoGauss_Fetch_v2b( ...
                u10, l_s, n_s, double(k), fetch_m, prec);

        case 'Apel'
            [H, X_h, ~, ~, ~, ~, ~] = f_GeneSurfMer2D_ElfoGauss_Fetch_v2b( ...
                u10, l_s, n_s, double(k), fetch_m, prec);

        case 'Donelan-Pierson'
            [H, X_h, ~, ~, ~, ~, ~] = f_GeneSurfMer2D_ElfoGauss_Fetch_v2b( ...
                u10, l_s, n_s, double(k), fetch_m, prec);
    end

    data.H = H(:);
    data.X = X_h(:);
end