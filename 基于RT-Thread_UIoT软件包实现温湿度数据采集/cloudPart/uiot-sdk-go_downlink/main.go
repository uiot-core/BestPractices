package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"github.com/ucloud/ucloud-sdk-go/ucloud"
	"github.com/ucloud/ucloud-sdk-go/ucloud/auth"
	"github.com/ucloud/ucloud-sdk-go/ucloud/log"
	"test/callapi/uiot"
	"time"
)

var uiotClient *uiot.UIotClient

const productSN = "your productsn"
const deviceSN = "your devicesn"
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