#############################
# Bijection Check Functions #
#############################

# Given a defined bijection f and a range of values x,
# checks that f is valid by asserting:
# f⁻¹(f(x)) = x
function check_roundtrip(f, xs; eq = isequal)
    all(eq(inverse(f)(f(x)), x) for x in xs)
end
