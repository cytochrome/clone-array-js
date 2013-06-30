
get-array-cloner-by-user-agent = (ua)->

    /* clone function
     * see http://jsperf.com/array-copy/9
     */
    tester   = -> it.test ua
    do-every = ( array, test ) ->
        for i til array.length
            if not test array[i]
                return false
        true

    get-cloner = (entries,default-functor) ->
        tester = -> it.test ua
        for entry in entries
            if do-every entry.matchers, tester
                return entry.functor
        default-functor

    functors =
        for-loop: ->
            dst = []
            for til it.length
                dst[i$] = it[i$]
            dst

        array-apply: ->
            Array.apply [], it

        decreasing-while-loop: ->
            len = src.length
            dst = []
            while len--
                dst[len] = arr[len]
            dst

        for-push-loop: ->
            for til it.length
                it[i$]

        slicer: ->
            Array.prototype.slice.call it

    get-cloner [{
        matchers: [/MSIE 1[0-9]+/]
        functor: functors.decreasing-while-loop
    },{
        matchers: [ /MSIE/ ]
        functor: functors.slicer
    },{
        matchers: [ /Chrom(e|ium)/, /Mobile|Android/ ]
        functor: functors.slicer
    },{
        matchers: [ /Chrom(e|ium)/ ]
        functor: functors.array-apply
    },{
        matchers: [ /Firefox/ ]
        functor: functors.for-push-loop
    }], functors.for-loop

clone-array = get-array-cloner-by-user-agent navigator?.user-agent or ""
