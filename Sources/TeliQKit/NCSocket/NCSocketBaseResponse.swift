/// 基础响应结构体
public struct NCSocketBaseResponse<T: Decodable>: Decodable {
    /// 状态
    public let status: String
    /// 返回码
    public let retcode: Int
    /// 数据
    public let data: T
    /// 消息
    public let message: String
    /// 提示语
    public let wording: String
    /// echo <-- 用于获取对应的返回
    public let echo: String
}
