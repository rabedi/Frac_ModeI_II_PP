function cfstruct = autofit(X,Y,Z,forcedType)
warning('off','curvefit:fit:noStartPoint');
warning('off','curvefit:fit:equationBadlyConditioned');
%AUTOFIT performs a best fit utilizing few of matlab library models for
%curve fitting and outputs the model with highest R^2 value.
% ref: https://www.mathworks.com/help/curvefit/fit.html#inputarg_fitType
% ref: https://www.mathworks.com/help/curvefit/list-of-library-models-for-curve-and-surface-fitting.html#btbcvnl
%for fittype function as third input to fit(x,y,fittype())
% ref: https://www.mathworks.com/help/curvefit/fittype.html

R2Tol = 1.0;

if nargin < 4
    forcedType = '';
end
if length(X) ~= length(Y)
   THROW('vector lengths must be same.'); 
end
if ~isempty(Z)
    if length(X) ~= length(Z)
        THROW('vector lengths must be same.'); 
    end
end

if size(X,2) ~= 1
    X = X';
end
if size(Y,2) ~= 1
    Y = Y';
end
if ~isempty(Z) && size(Z,2) ~= 1
    Z = Z';
end
%FIT TYPES
ftypes = {};
if isempty(Z)
ftypes = {'poly1',...
            'poly2',...
            'poly3',...
            'exp1',...
            'exp2',...
            'weibull',...
            'power1',...
            'power2',...
            'fourier1',...
            'fourier2',...
            'fourier3',...
            'gauss1',...
            'gauss2',...
            'gauss3'
        };
else
ftypes = {'poly11',...
            'poly21',...
            'poly31',...
            'poly12',...
            'poly22',...
            'poly32',...
            'poly13',...
            'poly23',...
            'poly33'
    };    
end
if ~isempty(forcedType)
    ftypes = {forcedType};
end
%BODY
ftSz = length(ftypes);
R2vals = NaN.*ones(ftSz,1);
cfitObjs = cell(ftSz,1);
for i = 1:ftSz
    gof = {};
    try
        if isempty(Z)
            [cfitObjs{i}, gof] = fit(X,Y,ftypes{i});
        else
            [cfitObjs{i}, gof] = fit([X,Y],Z,ftypes{i});
        end
    catch e
        continue;
    end
    R2vals(i) = gof.rsquare;
end
%[~, index] = max(R2vals);
R2vals = abs(R2Tol - R2vals);
[~, index] = min(R2vals);

%OUTPUT
if ~all(isnan(R2vals))
    outputfittype = fittype(ftypes{index});
    cNames = coeffnames(outputfittype)';
    cValues = coeffvalues(cfitObjs{index})';
    innerStruct = struct('names',{cNames},'values',[cValues]);
    cfstruct = struct('object',cfitObjs{index},... %can use feval(*.object,X) to evaluate at X 
                        'type',ftypes{i},...
                        'formula',formula(outputfittype),...
                        'coeffs',innerStruct,...
                        'Rsquared',R2vals(index));
else
    cfstruct = [];
end
                
warning('on','curvefit:fit:noStartPoint');
warning('on','curvefit:fit:equationBadlyConditioned');
end