function [Jval, grad] = test(theta)

global X;
global y;
Jval = computeCost(X, y, theta);
m = length(y);
grad = (X'*(X*theta-y)) / m;

end
