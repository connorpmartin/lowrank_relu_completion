#uniform_vectors generates a uniform packing of vectors on the unit r-ball
#definitely not optimal; this is a hard problem. look at the tammes problem / spherical codes
function uniform_vectors(min_dist = π/2,r = 5;magnitude=1)
    if r==2
        #this is a circle
        return magnitude .* [cos.(0:min_dist:2π) sin.(0:min_dist:2π)]
    end
    running_rows = [zeros(r-1)' magnitude;zeros(r-1)' -magnitude]
    for i in min_dist:min_dist:(π - min_dist)
        sol = uniform_vectors(min_dist,r-1;magnitude = sin(i))
        running_rows = cat(running_rows,[sol ones(size(sol,1))*magnitude*cos(i)],dims=1)
    end
    return running_rows
end