exports.fromError = function(a) {
  return a;
};

exports._toError = function(just, nothing, ref) {
  if (rej instanceof Error) {
    return just(ref);
  }
  return nothing;
};