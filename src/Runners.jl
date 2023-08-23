export onerun_spatialrust, parameters_experiment

function onerun_spatialrust(steps::Int = 730, side::Int = 100, maxlesions::Int = 25)
    # initialize model instance
    model = init_spatialrust(steps = steps, map_side = side, max_lesions = maxlesions)
    # run and collect data
    df = run_daily_spatialrust!(model, steps)

    return df
end

function run_daily_spatialrust!(model::SpatialRustABM, steps::Int)
    # initialize dataframe
    df = DataFrame(step = Int[], incidence = Float64[], severity = Float64[], production = Float64[])
    # simulate
    s = 0
    while s < steps
        # collect data
        push!(df, [s, incidence(model), severity(model), production(model)])
        # advance one time step
        step_model!(model)
        s += 1
    end
    # collect final state
    push!(df, [s, incidence(model), severity(model), production(model)])

    return df
end

function parameters_experiment(pars::DataFrame, parsorder::Vector{Symbol})
    # run model using each parameter combination
    dfs = map(run_par_combination, Tables.namedtupleiterator(pars))
    # collect all results in a single dataframe
    # df = reduce(vcat, dfs)
    df = DataFrame(dfs)
    # add parameter values to create output dataframe
    odf = hcat(select(pars, parsorder), df)

    return odf
end

function run_par_combination(pars::NamedTuple)
    # initialize model instance
    model = init_spatialrust(;pars...)
    # simulate and collect data
    stats = run_skip_spatialrust!(model, pars[:steps])

    return stats
end

function run_skip_spatialrust!(model::SpatialRustABM, steps::Int)
    # initialize dataframe
    # simulate
    s = 1 # starting at 1 instead of 0 to collect "final" rust states just before the new year updates
    while s < steps
        # advance one time step
        step_model!(model)
        s += 1
    end
    # get final incidence and severity, just before new year updates
    inc = incidence(model)
    sev = severity(model)
    # step once more
    step_model!(model)
    # output stats
    stats = (incidence = inc, severity = sev, farmproduction = model.current.prod / 1000)

    return stats
end