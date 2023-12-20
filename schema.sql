create table pixels_tmp
    engine = MergeTree() order by (advertiserId)
as
select *
from file('Pixels.tsv', 'TSVWithNames',
          '`advertiserId` Int64, `createdAt` DateTime64(9), `extId` String, `wlid` Nullable(Int64), `pixelId` Nullable(Int64), `ua` String, `ip` String, `geo` Nullable(String), `city` Nullable(String), `language` Nullable(String), `os` Nullable(String), `osVersion` Nullable(String), `browser` Nullable(String), `browserVersion` Nullable(String), `deviceMake` Nullable(String), `device` Nullable(String), `eventName` Nullable(String), `transactionId` Nullable(Int64), `amount` Nullable(Float64), `currency` Nullable(String), `site` Nullable(String), `clickId` Nullable(String), `bidreqId` Nullable(String), `productId` Nullable(Int64), `category` Nullable(String), `affId` Nullable(String), `s2s` Nullable(Int64), `userCreatedAt` Nullable(DateTime64 (9)), `page` Nullable(String), `createdDate` Nullable(Date), `hour` Nullable(Int64), `recordTs` Nullable(DateTime64 (9))');



create table pixels engine = MergeTree primary key (advertiserId, extId) as
select advertiserId,
       xxHash64(ip, ua) fpId,
       createdAt,
       extId,
       wlid,
       pixelId,
       ua,
       ip,
       geo,
       city,
       language,
       os,
       osVersion,
       browser,
       browserVersion,
       deviceMake,
       device,
       eventName,
       transactionId,
       amount,
       currency,
       site,
       clickId,
       bidreqId,
       productId,
       category,
       affId,
       s2s,
       userCreatedAt,
       page,
       createdDate,
       hour,
       recordTs
from pixels_tmp;



create table impressions
    engine = MergeTree primary key (advertiserId, extId) order by (advertiserId, extId, createdAt) as
select *
from file('Impressions.tsv', 'TSVWithNames',
          'id               Nullable(String),
           wlid             Nullable(Int64),
           bidreqId         Nullable(String),
           campaignId       Nullable(Int64),
           publisherId      Nullable(Int64),
           feedId           Nullable(Int64),
           advertiserId     Int64,
           paymentModel     Nullable(String),
           protocol         Nullable(String),
           protocolVersion  Nullable(String),
           endpointType     Nullable(String),
           adType           Nullable(String),
           inventoryType    Nullable(String),
           at               Nullable(Int64),
           fd               Nullable(Int64),
           zip              Nullable(Int64),
           security         Nullable(String),
           bidFloor         Nullable(String),
           ip               Nullable(String),
           geo              Nullable(String),
           region           Nullable(String),
           city             Nullable(String),
           latitude         Nullable(Int64),
           longitude        Nullable(Int64),
           language         Nullable(String),
           categories       Nullable(String),
           bcat             Nullable(String),
           keyword          Nullable(String),
           size             Nullable(String),
           sizeIcon         Nullable(String),
           creativeDuration Nullable(String),
           device           Nullable(String),
           deviceId         Nullable(String),
           deviceModel      Nullable(String),
           deviceMake       Nullable(String),
           os               Nullable(String),
           osVersion        Nullable(String),
           browser          Nullable(String),
           browserVersion   Nullable(String),
           connectionType   Nullable(Int64),
           carrier          Nullable(String),
           userId           Nullable(String),
           ifa              Nullable(String),
           sdate            Nullable(String),
           age              Nullable(Int64),
           gender           Nullable(String),
           status           Nullable(String),
           reason           Nullable(String),
           referrer         Nullable(String),
           dataCenter       Nullable(String),
           limit            Nullable(Int64),
           price            Nullable(String),
           payout           Nullable(String),
           payoutType       Nullable(String),
           bidPrice         Nullable(String),
           payoutRate       Nullable(Int64),
           currency         Nullable(String),
           appId            Nullable(String),
           appName          Nullable(String),
           appBundle        Nullable(String),
           siteId           Nullable(String),
           siteDomain       Nullable(String),
           subId            Nullable(String),
           tagId            Nullable(String),
           crId             Nullable(Int64),
           adomain          Nullable(String),
           viewType         Nullable(String),
           createdAt        DateTime64(9),
           createdDate      Nullable(Date),
           hour             Nullable(Int64),
           week             Nullable(Int64),
           month            Nullable(Int64),
           isFeed           Nullable(Int64),
           siteUrl          Nullable(String),
           bidreqIp         Nullable(String),
           ua               Nullable(String),
           fpId             UInt64,
           placements       Nullable(String),
           PlacementID      Nullable(Int64),
           placementId      Nullable(Int64),
           audinceId        Nullable(Int64),
           extId            String,
           audiences        Array(Nullable(Int64)),
           extIds           Array(Nullable(String)),
           userCreatedAt    Nullable(DateTime64(9)),
           uWlid            Nullable(Int64),
           uPublisherId     Nullable(Int64),
           sspId            Nullable(Int64),
           uSspId           Nullable(Int64),
           discrepancyRate  Nullable(String),
           weight           Nullable(Float64)');

create view last_impressions as
(
select advertiserId, extId, max(createdAt) createdAt
from impressions
group by advertiserId, extId
    );

