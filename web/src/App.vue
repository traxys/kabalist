<template>
  <v-app>
    <v-app-bar app>
        <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
        <v-toolbar-title>Lists</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn
          color="blue darken-1"
          text
          @click="logout()"
        >
          Logout
        </v-btn>
    </v-app-bar>

	<v-navigation-drawer
      v-model="drawer"
      absolute
      bottom
      temporary
    >
    <v-list
        nav
        dense
    >
      <v-subheader>LISTS {{this.username == null ? "" : `(${this.username})`}}</v-subheader>
      <v-list-item-group v-model="selectedList" color="primary" @change="selectList()">
       <v-list-item
          v-for="(item, i) in this.lists"
          :key="'list'+ i"
        >
          <v-list-item-content>
            <v-list-item-title v-text="formatTitle(item)"></v-list-item-title>
            <v-spacer></v-spacer>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
	</v-navigation-drawer>

  <v-dialog
      v-model="login"
      persistent
      max-width="600px"
  >
    <v-card>
      <v-card-title>Login</v-card-title>
      <v-card-text>
         <v-container>
          <v-row v-if="loginerror" class="red--text">
            <p>
              {{this.loginerror}}
            </p>
          </v-row>
          <v-row>
            <v-text-field v-model="username" label="Username" required></v-text-field>
          </v-row>
          <v-row>
            <v-text-field
              v-model="password"
              label="Password"
              required
              :append-icon="showpass ? 'mdi-eye' : 'mdi-eye-off'"
              :type="showpass ? 'text' : 'password'"
              @click:append="showpass = !showpass"
            ></v-text-field>
          </v-row>
         </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn
          color="blue darken-1"
          text
          @click="doLogin()"
        >
          Login
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog
      v-model="itemDialog"
      max-width="600px"
  >
    <v-card>
      <v-card-title>Add Item</v-card-title>
      <v-card-text>
        <v-container>
         <v-row>
           <v-text-field v-model="itemName" label="Name" required></v-text-field>
         </v-row>
         <v-row>
           <v-text-field
             v-model="itemAmount"
             label="Amount"
             required
           ></v-text-field>
         </v-row>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="doItemCancel()">Cancel</v-btn>
        <v-btn color="blue darken-1" text @click="doItemAdd()">Add</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog
      v-model="shareDialog"
      max-width="600px"
  >
    <v-card>
      <v-card-title>Share List</v-card-title>
      <v-card-text>
        <v-container>
         <v-row>
           <v-text-field v-model="shareWith" label="Share With" required></v-text-field>
         </v-row>
         <v-row>
         <v-checkbox v-model="shareReadonly" label="Readonly"></v-checkbox>
         </v-row>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="doShareCancel()">Cancel</v-btn>
        <v-btn color="blue darken-1" text @click="doShare()">Share</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-main>
    <v-container v-if="this.selectedList != null">
      <v-row justify="center">
        <v-card elevation="2" outlined width="50%">
          <v-card-title>
            <p>List: {{this.selectedName}}</p>
            <v-spacer></v-spacer>
            <v-btn text color="blue" @click="shareDialog = !shareDialog" v-if="!readonly">Share</v-btn>
          </v-card-title>
          <v-card-text>
            <v-list>
              <template v-for="(item, i) in items">
                <v-list-item :key="'items' + i">
                  <v-list-item-content>
                    <v-list-item-title v-text="formatItem(item)"></v-list-item-title>
                  </v-list-item-content>
                  <v-list-item-action v-if="!readonly">
                    <v-btn icon color="red" @click="deleteItem(item)">
                      <v-icon>mdi-delete</v-icon>
                    </v-btn>
                  </v-list-item-action>
                </v-list-item>
                <v-divider :key="'div' + i">
                </v-divider>
              </template>
            </v-list>
          </v-card-text>
          <v-card-actions v-if="!readonly">
            <v-spacer></v-spacer>
            <v-btn
              class="mx-2"
              fab
              dark
              large
              color="purple"
              @click.stop="itemDialog = !itemDialog"
            >
              <v-icon dark>
                mdi-pencil
              </v-icon>
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-row>
    </v-container>
  </v-main>

  </v-app>
</template>

<script>
const ENDPOINT = "http://localhost:8000";

export default {
	data: () => ({
		drawer: false,
    login: true,
    showpass: false,
    shareDialog: false,
    token: null,
    password: "",
    username: "",
    loginerror: null,
    lists: [],
    selectedList: null,
    content: null,
    itemDialog: false,
    itemAmount: "",
    itemName: "",
    shareWith: "",
    shareReadonly: false,
	}),
  computed: {
    readonly: function() {
      console.log(this.content?.readonly);
      return this.content?.readonly
    },
    items: function() {
      return this.content?.items
    },
    selectedId: function() {
      return this.lists[this.selectedList][1].id
    },
    selectedStatus: function () {
      return this.lists[this.selectedList][1].status
    },
    selectedName: function() {
      return this.lists[this.selectedList][0]
    }
  },
	created () {
		this.$vuetify.theme.dark = true
	},
  async mounted() {
		if(localStorage.token) {
			this.token = localStorage.token;
      this.username = localStorage.username;
      this.login = false;
      await this.fetchLists();
		}
	},
  methods: {
    logout () {
      this.token = null;
      localStorage.token = null;
      this.login = true;
      this.selectedList = null;
      this.content = null;
      this.lists = [];
    },
    doLogin: async function() {
      this.loginerror = null;
      const resp = await fetch(ENDPOINT + "/login", {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({password: this.password, username: this.username})
      })

      if(!resp.ok) {
        console.log(resp);
        this.error = "An unexpected error occured";
      } else {
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          this.token = resp_body.ok.token;
          localStorage.token = this.token;
          localStorage.username = this.username;
          this.login = false;
          this.password = "";
          await this.fetchLists();
        } else {
          this.loginerror = this.errorDesc(resp_body.err);
        }
      }
    },
    fetchLists: async function() {
      const resp = await fetch(ENDPOINT + "/list", {
        method: "GET",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          this.lists = Object.entries(resp_body.ok.results).sort((a,b) => a[0] > b[0]);
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }
    },
    selectList: async function() {
      this.drawer = false;
      await this.fetchContents();
    },
    fetchContents: async function() {
      const resp = await fetch(ENDPOINT + "/list/" + this.selectedId, {
        method: "GET",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          this.content = resp_body.ok;
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }
    },
    errorDesc(e) {
      switch(e.code) {
        case 0: {
          return "An internal error occured"
        }
        case 1: {
          return "The list already exists"
        }
        case 2: {
          return "Wrong username or password"
        }
        case 3: {
          return "The list is unknown"
        }
        case 4: {
          return "The list is readonly"
        }
      }
    },
    formatItem(item) {
      return item.name + (item.amount == null ? "" : ` (${item.amount})`)
    },
    formatTitle(item) {
      return `${item[0]} (${item[1].status})`
    },
    deleteItem: async function(item) {
      const resp = await fetch(ENDPOINT + "/list/" + this.selectedId + "/" + item.id, {
        method: "DELETE",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          await this.fetchContents();
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }
    },
    doItemCancel() {
      this.itemDialog = false;
      this.itemAmount = "";
      this.itemName = "";
    },
    doItemAdd: async function() {
      this.itemDialog = false;

      const resp = await fetch(ENDPOINT + "/list/" + this.selectedId, {
        method: "POST",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
        body: JSON.stringify({name: this.itemName, amount: this.itemAmount == "" ? null : this.itemAmount})
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          this.itemAmount = "";
          this.itemName = "";
          await this.fetchContents();
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }
    },
    doShareCancel() {
      this.shareDialog = false;
      this.shareWith = "";
      this.shareReadonly = false;
    },
    doShare: async function() {
      const nameResp = await fetch(ENDPOINT + "/search/account/" + this.shareWith, {
        method: "GET",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })

      let accountId;
      if(!nameResp.ok) {
        console.log(nameResp);
        alert("Unexpected error occured");
        return;
      } else{
        const resp_body = await nameResp.json();
        if("ok" in resp_body) {
          accountId = resp_body.ok.id;
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
          return;
        }
      }

      const resp = await fetch(ENDPOINT + "/share/" + this.selectedId, {
        method: "PUT",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
        body: JSON.stringify({share_with: accountId, readonly: this.shareReadonly})
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          this.shareDialog = false;
          this.shareWith = "";
          this.shareReadonly = false;
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }

    }
  }
}
</script>
