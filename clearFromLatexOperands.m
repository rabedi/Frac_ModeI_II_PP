function y = clearFromLatexOperands(x)  


y = readStringWithoutSpace(x, '\', '');
y = readStringWithoutSpace(y, '_', '');
y = readStringWithoutSpace(y, '^', '');
y = readStringWithoutSpace(y, '{', '');
y = readStringWithoutSpace(y, '}', '');
