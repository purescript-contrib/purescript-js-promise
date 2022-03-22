export function fromError(a) {
  return a;
}

export function _toError(just, nothing, ref) {
  if (ref instanceof Error) {
    return just(ref);
  }
  return nothing;
}
