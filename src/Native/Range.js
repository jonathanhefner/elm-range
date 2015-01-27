Elm.Native.Range = {};
Elm.Native.Range.make = function(localRuntime) {
    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.Range = localRuntime.Native.Range || {};
    if (localRuntime.Native.Range.values)
    {
        return localRuntime.Native.Range.values;
    }
    if ('values' in Elm.Native.Range)
    {
        return localRuntime.Native.Range.values = Elm.Native.Range.values;
    }

    function foldl(f, b, range) {
        var acc = b;
        var step = range._1 < range._0 ? -1 : 1;
        for (var i = range._0; i != range._1; i += step) {
            acc = A2(f, i, acc);
        }
        return acc;
    }

    Elm.Native.Range.values = {
        foldl:F3(foldl),
    };
    return localRuntime.Native.Range.values = Elm.Native.Range.values;

};
