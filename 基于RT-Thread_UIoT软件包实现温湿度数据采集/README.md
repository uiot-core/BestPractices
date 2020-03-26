



# 基于RT-Thread UIoT软件包实现温湿度数据采集

 

本文详细介绍基于RT-Thread 使用UCloud IoT软件包实现数据上云，以及设备远程控制。

【视频演示】：[上行--采集温湿度数据上云.mp4](https://www.bilibili.com/video/BV1D7411y71n/)    [下行--业务服务下发控制消息.mp4](https://www.bilibili.com/video/BV1D7411y7HK/)

 

#### 准备工作：

- **硬件：** 开发板STM32F767ZI-Nucleo，通信模块 EC20，温湿度传感器DTH11

- **软件：** RT-Thread Studio，UIoT物联网软件包

- **云资源：** [注册UCloud账号](https://passport.ucloud.cn/?invitation_code=C1xF974651066CB)，开通UIoT物联网通信云平台，云主机1台

 

#### 环境搭建：

- 系统框架

![img](./images/clip_image001.png)

- 搭建实拍

![img](./images/clip_image003.png)

## 温湿度采集详细教程（上行）：

1. [下载RT-Thread Studio]( https://www.rt-thread.org/page/studio.html)

2. 安装软件并打开RT-Thread，登录RT-Thread Studio(需要注册)

3. 创建RT-Thread项目

   ![img](./images/clip_image006.png)

4. 选择UCloud UIoT软件包

   ![img](./images/clip_image008.png)

5.  参考文档【创建产品、创建设备(https://docs.ucloud.cn/iot/uiot-core/console_guide/product_device/create_products)】获取产品序列号ProductSN、设备序列号DeviceSN、设备密钥DeviceSecret，用于接入物联网平台

   ![img](./images/clip_image010.png)

注：UCloud物联网通信云平台基于标准的MQTT协议具体参数的生成可以参考(https://docs.ucloud.cn/iot/uiot-core/device_develop_guide/deviceconnect/mqttconnect)。

6. 配置UIoT软件包

   ![img](./images/clip_image012.png)

7.  配置AT软件包，配置AT模组EC20，（串口设备名称、电源引脚、接收缓存）

   ![img](./images/clip_image014.png)

8.  配置DHT11软件包

   ![img](./images/clip_image016.png)

9. 其他配置

   - 配置libc支持

   ​    ![img](./images/clip_image018.png)

   -  配置AT模组需要的串口设备

   ​     ![img](./images/clip_image020.png)

10.  保存上述配置

    ![img](./images/clip_image022.png)

11. 修改`dht11_sample.c`，修改头文件`drv_gpio.h`为`board.h`, 删除`static void read_temp_entry(void *parameter)`和`static int dht11_read_temp_sample(void)`函数，将读取温湿度的流程放到`mqtt_sample.c`中

    ![img](./images/clip_image00111.png)

12. 修改`mqtt_sample.c`，添加DHT11读取温湿度，并通过`Topic：/${ProductSN}/${DeviceSN}/upload/event`  publish消息到Ucloud物联网云平台

    - 添加头文件   ​   

      ![img](./images/clip_image00311.png) 

    - 修改`static int _publish_msg(void *client, msg_payload payload)` 函数上报温湿度   ​ 

      ![img](./images/clip_image00511.png)

    - 在`static void mqtt_test_thread(void)`函数中添加DHT11温湿度读取代码![img](./images/clip_image00711.png)![img](./images/clip_image00911.png)

    - 修改`void mqtt_test_example (void)`，并创建一个头文件声明该函数   ​   ![img](./images/clip_image01111.png)
     ![img](./images/clip_image01311.png)
    
        **注：** `mqtt_sample.c`完成的工作包括： ①监听MQTT Topic：`/${ProductSN}/${DeviceSN}/upload/event `；②发送消息到MQTT Topic：`/${ProductSN}/${DeviceSN}/upload/event`。`mqtt_sample.c`中为了方便观察测试结果，使用的Topic同时具有发布&订阅权限，实际使用中建议参考[Topic管理](https://docs.ucloud.cn/iot/uiot-core/console_guide/product_device/topic)分别定义发布、订阅权限的Topic用于上下行通信。 
    
    - 在main函数中调用void mqtt_test_example (void)  ​  ![img](./images/clip_image01511.png)


13. 编译并下载到目标开发板

    ![img](./images/clip_image034.png)

14. 规则引擎转发到http server

    - 准备httpserver，本例使用golang写一个监听8900，path为receive的http server，并将收到的数据打印

      ```go
      package main
      
      import (
      "encoding/hex"
      "fmt"
      "io/ioutil"
      "net/http"
      )
      
      func IndexHandler(w http.ResponseWriter, r *http.Request) {
         s,_ := ioutil.ReadAll(r.Body)
         //fmt.Println(time.Now().Local().String()+string(s))
         hexdump := hex.Dump(s)
         fmt.Print(hexdump)
      }
      
      func main() {
         http.HandleFunc("/receive", IndexHandler)
         http.ListenAndServe(":8900", nil)
      }
      ```

    - 配置规则引擎

      ![img](./images/clip_image036.png) 

    - 后端业务服务器收到上行数据，与云平台日志记录相同

      ![img](./images/clip_image038.png)

      ![img](./images/clip_image040.png)

      
      

## 业务服务下发控制消息（下行）详细教程：

调用API调用下发消息，参考文档[消息通信](https://docs.ucloud.cn/iot/uiot-core/api_guide/messagemgmtapi)，调用流程可以参考[关于api接入](https://docs.ucloud.cn/uiot-core/api_guide/api_guidehelp)。

### 消息下发（基于golang）

1. 获取SDK调用框架

   ```shell
   git clone https://github.com/ucloud/ucloud-sdk-go.git
   ```

2. 参考uhost代码：`services/uhost/apis.go`，创建`uiot/api.go`：

   ```go
   package uiot
   
   import (
     "github.com/ucloud/ucloud-sdk-go/ucloud/request"
     "github.com/ucloud/ucloud-sdk-go/ucloud/response"
    )
   
   // PublishUIoTCoreMQTTMessage
   type PublishUIoTCoreMQTTMessageRequest struct {
      request.CommonBase
      ProductSN *string `required:"true"`
      DeviceSN *string `required:"ture"`
      TopicFullName *string
      MessageContent *string
      Qos int
   }
   type PublishUIoTCoreMQTTMessageResponse struct {
      response.CommonBase
      Payload  interface{}
   }
   
   func (c *UIotClient) PublishUIoTCoreMQTTMessage(req *PublishUIoTCoreMQTTMessageRequest) (*PublishUIoTCoreMQTTMessageResponse, error){
      c.Client.SetupRequest(req)
      req.SetRetryable(false)
      resp:= PublishUIoTCoreMQTTMessageResponse{}
      err := c.Client.InvokeAction("PublishUIoTCoreMQTTMessage", req, &resp)
      if err != nil {
         return &resp, err
      }
      return &resp, nil
   }
   ```

   

3. 参考uhost代码：`services/uhost/client.go`，创建`uiot/client.go`：

   ```go
   package uiot
   
   import (
      "github.com/ucloud/ucloud-sdk-go/ucloud"
      "github.com/ucloud/ucloud-sdk-go/ucloud/auth"
   )
   
   
   // UIoTClient is the client of UHost
   type UIotClient struct {
      *ucloud.Client
   }
   
   // NewClient will return a instance of UHostClient
   func NewClient(config *ucloud.Config, credential *auth.Credential) *UIotClient {
      client := ucloud.NewClient(config, credential)
      return &UIotClient{
         client,
      }
   }
   ```

4. 参考uhost example代码：`examples/uhost/main.go`，创建`main.go`

   ```go
   package main
   
   import (
      "encoding/base64"
      "encoding/json"
      "fmt"
      "github.com/ucloud/ucloud-sdk-go/ucloud"
      "github.com/ucloud/ucloud-sdk-go/ucloud/auth"
      "github.com/ucloud/ucloud-sdk-go/ucloud/log"
      "./uiot"
      "time"
   )
   
   var uiotClient *uiot.UIotClient
   
   // 修改属于你的内容
   const productSN = "your productsn"
   const deviceSN = "your devicesn"
   const deviceSecret = "your devicesecret"
   const region = "cn-sh2"
   const zone = "cn-sh2-02"
   const projectid = "your projectid"
   const privateKey = "your privatekey"
   const publicKey = "your publickey"
   
   func main() {
   cfg, credential := loadConfig()
      cfg.BaseUrl = "https://api-cn-sh2.iot.ucloud.cn"
   uiotClient = uiot.NewClient(cfg, credential)
   
      /* Send downlink message */
         ticker := time.NewTicker(500 * time.Millisecond)
         for {
            select {
            case <-ticker.C:
               PublishUIoTCoreMQTTMessage()
            }
         }
   }
   
   func PublishUIoTCoreMQTTMessage() {
         req := uiot.PublishUIoTCoreMQTTMessageRequest{}
         req.ProductSN = ucloud.String(productSN)
         req.DeviceSN = ucloud.String(deviceSN)
         //req.Zone = ucloud.String(zone)
   
         // binary message
         req.TopicFullName = ucloud.String(`/` + productSN + `/` + deviceSN + `/downlink`)
         bs := []byte{0x01, 0x22, 0x23, 0x87, 0xF3, 0xA1}
         req.MessageContent = ucloud.String(base64.StdEncoding.EncodeToString(bs))
         req.Qos = 1
         resp, err := uiotClient.PublishUIoTCoreMQTTMessage(&req)
       
         if err != nil {
            fmt.Println(err)
         } else {
            strresp, _ := json.Marshal(resp)
            _ = strresp
            fmt.Println(string(strresp))
         }
       
         // json message
         req.TopicFullName = ucloud.String(`/` + productSN + `/` + deviceSN + `/downlink`)
         req.MessageContent = ucloud.String(ToBase64(`{"test":1}`))
         resp, err = uiotClient.PublishUIoTCoreMQTTMessage(&req)
       
         if err != nil {
            fmt.Println(err)
         } else {
            strresp, _ := json.Marshal(resp)
            _ = strresp
            fmt.Println(string(strresp))
         }
   }
   
   
   func loadConfig() (*ucloud.Config, *auth.Credential) {
      cfg := ucloud.NewConfig()
      cfg.LogLevel = log.DebugLevel
      cfg.LogLevel = log.ErrorLevel
      cfg.Region = region
      cfg.ProjectId = projectid
      cfg.Zone = zone
      cfg.BaseUrl = "https://api-cn-sh2.iot.ucloud.cn"
   
      credential := auth.NewCredential()
      credential.PrivateKey = privateKey
      credential.PublicKey = publicKey
   
      log.Info("setup clients ...")
   
      return &cfg, &credential
   }
   
   func ToBase64(str string) string {
      return base64.StdEncoding.EncodeToString([]byte(str))
   }
   ```

5. 最终目录结构

    ![img](./images/clip_image042.png)


6. 运行程序，下发数据

   - 通过日志查看下发成功

     ![img](./images/clip_image0016.png)

   - 设备端打印查看下发消息成功

     ![img](./images/clip_image0036.png)

 

 

