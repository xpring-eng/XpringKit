internal extension XRPMemo {
  init(memo: Org_Xrpl_Rpc_V1_Memo) {
    self.data = memo.hasMemoData ? memo.memoData.value : nil
    self.format = memo.hasMemoFormat ? memo.memoFormat.value : nil
    self.type = memo.hasMemoType ? memo.memoType.value : nil
  }
}
