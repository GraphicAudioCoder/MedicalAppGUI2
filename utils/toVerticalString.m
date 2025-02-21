% /utilis/toVerticalString.m

function verticalStr = toVerticalString(inputStr)
    upperStr = upper(inputStr);
    verticalStr = join(cellstr(upperStr(:)), sprintf('\n'));
end
