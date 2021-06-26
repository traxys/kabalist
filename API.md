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
		"<complete_name>": "<list_id>"
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

## `/share/<list_id:uuid>`

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
		"<complete_name>": "<list_id>"
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
