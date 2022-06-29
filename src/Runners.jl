export onerun_spatialrust, parameters_experiment

function onerun_spatialrust(steps::Int = 1095, side::Int = 100, maxlesions::Int = 25)
    pars = Parameters(steps = steps, map_side = side, max_lesions = maxlesions)
    model = init_spatialrust(pars, create_midshade_farm_map(), create_weather(pars.rain_prob, pars.wind_prob, pars.mean_temp, pars.steps))
    
    _, m_df = run!(model, dummystep, step_model!, steps;
        mdata = [incidence, severity, production])

    return m_df
end

function parameters_experiment(conds::Dict{Symbol, Any})
    combinations = dict_list(conds)
    dfs = map(run_par_combination, combinations)
    df = reduce(vcat, dfs)
    return df
end

function run_par_combination(combination::Dict{Symbol, Any})
    pop!(combination, :reps)
    pars = Parameters(; combination...)

    model = init_spatialrust(pars) 
    _, mdf = run!(model, dummystep, step_model!, pars.steps;
        when_model = [pars.steps],
        mdata = [incidence, severity, production])
        
    pars_to_df = filter(p -> p[1] in (:mean_temp, :rain_prob, :wind_prob), combination)

    df = hcat(DataFrame(pars_to_df), mdf[:, Not(:step)])
    return df
end
