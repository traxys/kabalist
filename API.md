# API description

All `[AUTH]` requests must include a correct `Bearer` token.

## `/login`

### POST

Generates a `Bearer` token.

#### Request
```json
{
	"username": "...",
	"password": "..."
}
```

#### Reply 
```json
{
	"token": "..."
}
```

## `/register/<id>`

### POST

Consumes the register token `id` and creates an account

#### Request
```json
{
	"username": "...",
	"password": "..."
}
```

#### Reply

No body

## `/list`

### `[AUTH]` POST

Creates a new list

#### Request
```json
{
	"name": "...",
}
```

#### Reply
```json
{
	"id": "uuid",
}
```

### `[AUTH]` GET

Get all the lists owned or shared

#### Request

Empty Body

#### Reply
```json
{
	"results": {
		"<complete_name>": {
			"id": "<list_id>",
			"status": "owned/shared_write/shared_read"
		}
	}
}
```

## `/list/<id:uuid>`

### `[AUTH]` GET

Get all items in the list `id`

#### Request

Empty Body

#### Reply
```json
{
	"readonly": true,
	"items": [{
		"id": 123,
		"name": "...",
		"amount": "string or null"
	}]
}
```

### `[AUTH]` POST

Add an item to the list `id`

#### Request
```json
{
	"name": "...",
	"amount": "string or null"
}
```

#### Response
```json
{
	"id": 123
}
```

### `[AUTH]` DELETE

Delete a list

#### Request

Empty body

#### Reply

Empty request

## `/list/<list:uuid>/<item:i32>`

### `[AUTH]` DELETE

Delete the `item` from the `list`

#### Request

Empty Body

#### Reply

Empty Body

## `/share/<list_id:uuid/<account_id:uuid>`

### `[AUTH]` DELETE

#### Request

Empty Body

#### Reply

Empty Reply

## `/share/<list_id:uuid>`

### `[AUTH]` GET

#### Request 

Empty Body

#### Reply
```json
{
	"public_url": "null/url",
	"shared_with": [
		["account:uuid", "bool:readonly"]
	]
}
```

### `[AUTH]` PUT

Share the list `list_id` with another account

#### Request
```json
{
	"share_with": "uuid",
	"readonly": true,
}
```

#### Reply

Empty Reply

### `[AUTH]` DELETE

Unshare the list with all people

#### Request

Empty Body

#### Reply

Empty Body

## `/search/list/<name:string>`

### `[AUTH]` GET

Searches for lists that contain `name`

#### Request

Empty Body

#### Reply 
```json
{
	"results": {
		"<complete_name>": {
			"id": "<list_id>",
			"status": "owned/shared_write/shared_read"
		}
	}
}
```

## `/search/account/<name:string>`

### `[AUTH]` GET

Get the account id for the corresponding name

#### Request

Empty Body

#### Reply
```json
{
	"id": "uuid",
}
```

## `/recover/<id:uuid>`

### GET

Get the account name for the recovery id

#### Request

Empty Body

#### Reply 
```json
{
	"username": "...",
}
```

### POST

Recover the password, consuming the `id`

#### Request 
```json
{
	"password": "...",
}
```

#### Reply

Empty Reply
