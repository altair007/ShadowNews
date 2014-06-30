用于记录项目期间遇到的各种BUG原因和解决方案:
## 使用 AFNetWorking时能够获取从网络获取json数据,但是无法解析.
* 错误位置:SNShadowNewsModel 类 localNews:range:success:fail:方法.
* 错误详情:

```
Error Domain=com.alamofire.error.serialization.response Code=-1016 "Request failed: unacceptable content-type: text/html" UserInfo=0x10939a760 {com.alamofire.serialization.response.error.response=<NSHTTPURLResponse: 0x10944f680> { URL: http://c.3g.163.com/nc/article/local/5YyX5Lqs/0-20.html } { status code: 200, headers {
    "Cache-Control" = "max-age=240";
    Connection = "keep-alive";
    "Content-Encoding" = gzip;
    "Content-Type" = "text/html; charset=UTF-8";
    Date = "Mon, 30 Jun 2014 05:18:00 GMT";
    Expires = "Mon, 30 Jun 2014 05:22:00 GMT";
    "Last-Modified" = "Mon, 30 Jun 2014 05:06:23 GMT";
    Server = nginx;
    "Transfer-Encoding" = Identity;
    Vary = "Accept-Encoding";
    Via = "c-3g-163-com-52.76";
    "X_cache" = "HIT from zeta-c3g1.sa.bgp.hz";
} }, NSLocalizedDescription=Request failed: unacceptable content-type: text/html, NSErrorFailingURLKey=http://c.3g.163.com/nc/article/local/5YyX5Lqs/0-20.html}

```
* 解决方案:     

```
manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"]
```