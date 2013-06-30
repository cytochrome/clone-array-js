var getArrayClonerByUserAgent, cloneArray;
getArrayClonerByUserAgent = function(ua){
  /* clone function
   * see http://jsperf.com/array-copy/9
   */
  var tester, doEvery, getCloner, functors;
  tester = function(it){
    return it.test(ua);
  };
  doEvery = function(array, test){
    var i$, to$, i;
    for (i$ = 0, to$ = array.length; i$ < to$; ++i$) {
      i = i$;
      if (!test(array[i])) {
        return false;
      }
    }
    return true;
  };
  getCloner = function(entries, defaultFunctor){
    var tester, i$, len$, entry;
    tester = function(it){
      return it.test(ua);
    };
    for (i$ = 0, len$ = entries.length; i$ < len$; ++i$) {
      entry = entries[i$];
      if (doEvery(entry.matchers, tester)) {
        return entry.functor;
      }
    }
    return defaultFunctor;
  };
  functors = {
    forLoop: function(it){
      var dst, i$, to$;
      dst = [];
      for (i$ = 0, to$ = it.length; i$ < to$; ++i$) {
        dst[i$] = it[i$];
      }
      return dst;
    },
    arrayApply: function(it){
      return Array.apply([], it);
    },
    decreasingWhileLoop: function(){
      var len, dst;
      len = src.length;
      dst = [];
      while (len--) {
        dst[len] = arr[len];
      }
      return dst;
    },
    forPushLoop: function(it){
      var i$, to$, results$ = [];
      for (i$ = 0, to$ = it.length; i$ < to$; ++i$) {
        results$.push(it[i$]);
      }
      return results$;
    },
    slicer: function(it){
      return Array.prototype.slice.call(it);
    }
  };
  return getCloner([
    {
      matchers: [/MSIE 1[0-9]+/],
      functor: functors.decreasingWhileLoop
    }, {
      matchers: [/MSIE/],
      functor: functors.slicer
    }, {
      matchers: [/Chrom(e|ium)/, /Mobile|Android/],
      functor: functors.slicer
    }, {
      matchers: [/Chrom(e|ium)/],
      functor: functors.arrayApply
    }, {
      matchers: [/Firefox/],
      functor: functors.forPushLoop
    }
  ], functors.forLoop);
};
cloneArray = getArrayClonerByUserAgent(typeof navigator != 'undefined' && navigator !== null ? navigator.userAgent : void 8) || "";