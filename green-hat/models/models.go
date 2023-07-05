package models

type RoadDataInput struct {
	Timestamp string      `json:"timestamp"`
	Latitude  float64     `json:"latitude"`
	Longitude float64     `json:"longitude"`
	NoPpb     interface{} `json:"no_ppb"`
	No2Ppb    float64     `json:"no2_ppb"`
	O3Ppb     interface{} `json:"o3_ppb"`
	CoPpm     float64     `json:"co_ppm"`
	Co2Ppm    float64     `json:"co2_ppm"`
	Pmch1Perl int         `json:"pmch1_perl"`
	Pmch2Perl int         `json:"pmch2_perl"`
	Pmch3Perl int         `json:"pmch3_perl"`
	Pmch4Perl int         `json:"pmch4_perl"`
	Pmch5Perl int         `json:"pmch5_perl"`
	Pmch6Perl int         `json:"pmch6_perl"`
	Pm25Ugm3  float64     `json:"pm25_ugm3"`
}
