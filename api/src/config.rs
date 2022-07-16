use std::net::IpAddr;

use serde::{Deserialize, Deserializer, Serialize, Serializer};

pub(crate) struct Base64(pub(crate) Vec<u8>);

impl std::fmt::Debug for Base64 {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, r#"b64"{}""#, &base64::encode(&self.0))
    }
}

impl Serialize for Base64 {
    fn serialize<S>(&self, ser: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        ser.serialize_str(&base64::encode(&self.0))
    }
}

impl<'de> Deserialize<'de> for Base64 {
    fn deserialize<D>(de: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        use serde::de::Visitor;

        struct DecodingVisitor;
        impl<'de> Visitor<'de> for DecodingVisitor {
            type Value = Base64;

            fn expecting(&self, formatter: &mut std::fmt::Formatter) -> std::fmt::Result {
                formatter.write_str("must be a base 64 string")
            }

            fn visit_str<E>(self, v: &str) -> Result<Self::Value, E>
            where
                E: serde::de::Error,
            {
                base64::decode(v).map_err(E::custom).map(Base64)
            }
        }

        de.deserialize_str(DecodingVisitor)
    }
}

#[derive(Deserialize, Debug, Serialize)]
pub(crate) struct Config {
    pub(crate) database_url: String,
    pub(crate) jwt_secret: Base64,
    pub(crate) exp: usize,
    pub(crate) listen_addr: IpAddr,
    pub(crate) port: u16,
    #[cfg(feature = "frontend")]
    pub(crate) frontend: Option<std::path::PathBuf>,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            database_url: "postgres://postgres:password@localhost/postgres".into(),
            jwt_secret: Base64(b"kabalist_secret".to_vec()),
            exp: 1000000,
            listen_addr: [127, 0, 0, 1].into(),
            port: 8080,
            frontend: None,
        }
    }
}
