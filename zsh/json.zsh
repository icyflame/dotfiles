# array_to_object converts an array of objects with one key each to a single
# object with those keys:
# Input:  [ { a: { ... } }, { b: n1 }, { c: v2 } ]
# Output: { a: { ... }, b: n1, c: v2 }
function array_to_object () {
    jq '. | reduce .[] as $comp ({}; . + ($comp | keys | first) as $key | { ($key): $comp[$key] })'
}
