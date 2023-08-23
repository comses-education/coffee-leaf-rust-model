# Functions to retrieve agent metrics

incidence(model::ABM) = mean(a -> (a.n_lesions > 0), model.agents)

severity(model::ABM) = mean(a -> rusted_area(a), model.agents)

production(model::ABM) = mean(a -> a.production, model.agents)

rusted_area(rust::Coffee) = sum(rust.areas, init = 0.0)

active(c::Coffee) = c.exh_countdown == 0