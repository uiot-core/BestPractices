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
