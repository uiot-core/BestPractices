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
