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
