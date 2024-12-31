package main

import (
	"fmt"
	"io"
	"net/http"
	"os"

	alidns "github.com/alibabacloud-go/alidns-20150109/v2/client"
	openapi "github.com/alibabacloud-go/darabonba-openapi/client"
	"github.com/alibabacloud-go/tea/tea"
)

const (
	DOMAIN = "koumakan.cc"
)

func GetPubIP() string {
	req, err := http.NewRequest(http.MethodGet, "https://api64.ipify.org", nil)
	if err != nil {
		panic(err)
	}

	req.Header.Set("User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0")
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		panic(err)
	}

	defer res.Body.Close()
	data, err := io.ReadAll(res.Body)
	if err != nil {
		panic(err)
	}

	ret := string(data)
	fmt.Println("pub ip", ret)
	return ret
}

func UpdateDDNS(ip string) {
	id, err := os.ReadFile("/run/secrets/ddns/id")
	if err != nil {
		panic(err)
	}
	secret, err := os.ReadFile("/run/secrets/ddns/secret")
	if err != nil {
		panic(err)
	}

	config := &openapi.Config{
		AccessKeyId:     tea.String(string(id)),
		AccessKeySecret: tea.String(string(secret)),
	}
	client, err := alidns.NewClient(config)
	if err != nil {
		panic(err)
	}

	req1 := &alidns.DescribeDomainRecordInfoRequest{}
	req1.RecordId = tea.String("845466758563818496")
	res1, err := client.DescribeDomainRecordInfo(req1)
	if err != nil {
		panic(err)
	}
	if *res1.Body.Value == ip {
		fmt.Println("same ip, skip")
		return
	}

	req2 := &alidns.UpdateDomainRecordRequest{}
	req2.RecordId = tea.String("845466758563818496")
	req2.Type = tea.String("A")
	req2.RR = tea.String("dgsh")
	req2.Value = tea.String(ip)
	res2, err := client.UpdateDomainRecord(req2)
	if err != nil {
		panic(err)
	}
	fmt.Println(res2.Body)
}

func main() {
	UpdateDDNS(GetPubIP())
	//UpdateDDNS("154.17.21.145")
}
