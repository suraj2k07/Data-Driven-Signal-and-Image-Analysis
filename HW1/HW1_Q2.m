function newMean = UpdateMean (OldMean, NewDataValue, n)
    newMean=((OldMean*n)+NewDataValue)/(n+1);
end
function newStd = UpdateStd (OldMean, OldStd, NewMean, NewDataValue, n)
    newStd=sqrt(( ((n-1)*(OldStd^2)) +(NewDataValue-NewMean)^2 + (n*((OldMean-NewMean)^2)))/n);
end
function newMedian = UpdateMedian (oldMedian, NewDataValue, A, n)
    if mod(n,2)==0
        if NewDataValue > A((n/2)+1)
            newMedian = A((n/2)+1);
        elseif NewDataValue < A(n/2)
            newMedian = A(n/2);
        else
            newMedian=NewDataValue;
        end
    else 
        if NewDataValue >= A((n+3)/2)
            newMedian = (oldMedian+A((n+3)/2))/2;
        elseif NewDataValue <= A((n-1)/2)
            newMedian = (oldMedian+A((n-1)/2))/2;
        else 
            newMedian = (oldMedian+NewDataValue)/2;
        end
    end
end