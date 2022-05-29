# Functions to retrieve model/agent metrics

incidence(model::ABM) = length(model.current.rust_ids) / length(model.current.coffee_ids)

severity(model::ABM) = median(rusted_area(model[rid]) for rid in model.current.rust_ids)

production(model::ABM) = median(model[cid].production for cid in model.current.coffee_ids)

rusted_area(rust::Rust) = sum(rust.state[2,:])

# Filters

justcofs(a) = a isa Coffee
justrusts(a) = a isa Rust
