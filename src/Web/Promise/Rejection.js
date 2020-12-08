"use strict";

exports.fromError = function(a) {
  return a;
};

exports._toError = function(just, nothing, ref) {
  if (ref instanceof Error) {
    return just(ref);
  }
  return nothing;
};
