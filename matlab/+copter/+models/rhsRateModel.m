function domega = rhsRateModel(~, omega, input, model)
% Правая часть модели угловых скоростей.

omega = double(omega(:));
input = double(input(:));
domega = model.A * omega + model.B * input + model.c(:);
end
