function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables


% You need to return the following variables correctly
J = 0;
Theta1_grad = zeros(size(Theta1)); % 25 X 401
Theta2_grad = zeros(size(Theta2)); % 10 x 26

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
m = size(X,1);
A1 = [ones(m,1), X]; % 5000 x 401
Z2 = A1*Theta1'; % 5000 x 25
A2 = [ones(m,1), sigmoid(Z2)]; % 5000 x 26
Z3 = A2*Theta2'; % 5000 x 10
H = sigmoid(Z3);% 5000 x 10

Y = zeros(m,num_labels); % 5000 x 10.
for k = 1:num_labels,
    Y(:,k) = (y==k);
end

Cost = (Y.*log(H)+(1.-Y).*log(1-H))/(-m); % 5000 x 10

theta_wo_bias = [Theta1(:,2:end)(:) ; Theta2(:,2:end)(:)];
reg_term = sum(theta_wo_bias.^2)*lambda/(2*m);
J = sum(sum(Cost)) + reg_term;

delta3 = H.-Y; % 5000 X 10
delta2 = delta3*Theta2.*A2.*(1-A2); % 5000 x 26
delta2 = delta2(:,2:end); % 5000 x 25

for i = 1:m,
    D2_tmp = delta3(i,:)'*A2(i,:);
    Theta2_grad = Theta2_grad .+ D2_tmp;

    D1_tmp =  delta2(i,:)'*A1(i,:);
    Theta1_grad = Theta1_grad .+ D1_tmp;
end

Theta1_reg = lambda.*[zeros(size(Theta1,1),1),Theta1(:,2:end)];
Theta2_reg = lambda.*[zeros(size(Theta2,1),1),Theta2(:,2:end)];

Theta1_grad = Theta1_grad .+ Theta1_reg;
Theta2_grad = Theta2_grad .+ Theta2_reg;

Theta2_grad = Theta2_grad ./m;
Theta1_grad = Theta1_grad ./m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
