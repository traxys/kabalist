<template>
  <v-app>
    <v-app-bar app>
        <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
        <v-toolbar-title>KabaList</v-toolbar-title>
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
      <v-list-item @click="addList()">
         <v-list-item-icon>
         <v-icon>mdi-playlist-edit</v-icon>
         </v-list-item-icon>
        <v-list-item-title class="text-h6">Add List</v-list-item-title>
      </v-list-item>
      <v-list-item-group v-model="selectedList" color="primary" @change="selectList()">
      <v-divider></v-divider>
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
      v-model="recover"
      persistent
      max-width="600px"
  >
    <v-card>
      <v-card-title>Recover password for {{username}}</v-card-title>
      <v-card-text>
         <v-container>
          <v-row v-if="recovererror" class="red--text">
            <p>
              {{this.recovererror}}
            </p>
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
          @click="doRecover()"
        >
          Change Password
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog
      v-model="register"
      persistent
      max-width="600px"
  >
    <v-card>
      <v-card-title>Register</v-card-title>
      <v-card-text>
         <v-container>
          <v-row v-if="registererror" class="red--text">
            <p>
              {{this.registererror}}
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
          @click="doRegister()"
        >
          Register
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
      v-model="editDialog"
      max-width="600px"
  >
    <v-card>
      <v-card-title>Edit Item</v-card-title>
      <v-card-text>
        <v-container>
         <v-row>
           <v-text-field v-model="editItemName" label="Name" required></v-text-field>
         </v-row>
         <v-row>
           <v-text-field
             v-model="editItemAmount"
             label="Amount"
             required
           ></v-text-field>
         </v-row>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="doItemCancel()">Cancel</v-btn>
        <v-btn color="blue darken-1" text @click="doItemEdit()">Add</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog
      v-model="deleteDialog"
      max-width="600px"
  >
    <v-card>
      <v-card-title>Delete List</v-card-title>
      <v-card-text>
        Are you sure you want to delete the list ?
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="deleteDialog = !deleteDialog">Cancel</v-btn>
        <v-btn color="blue darken-1" text @click="doDelete()">Delete</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog
      v-model="shareDialog"
      max-width="600px"
  >
    <v-card>
      <v-card-title>Manage Shares</v-card-title>
      <v-card-text>
        <v-container>
         <v-row v-if="selectedPublic" justify="center">
          <p>Public url: {{ENDPOINT + "/public/" + this.selectedId}}</p>
         </v-row>
         <v-row v-if="owned" justify="center">
          <v-btn color="red darken-1" text @click="removePublic()" v-if="selectedPublic">Remove Public</v-btn>
          <v-btn color="blue darken-1" text @click="setPublic()" v-if="!selectedPublic">Set Public</v-btn>
         </v-row>
         <v-list>
           <template v-for="(share, i) in shares">
             <v-list-item :key="'share' + i">
               <v-list-item-content>
                 <v-list-item-title v-text="formatShare(share)"></v-list-item-title>
               </v-list-item-content>
               <v-list-item-action v-if="owned">
                 <v-row>
                   <v-btn icon color="red" @click="deleteShare(share)">
                     <v-icon>mdi-delete</v-icon>
                   </v-btn>
                 </v-row>
               </v-list-item-action>
             </v-list-item>
             <v-divider :key="'divshare' + i">
             </v-divider>
           </template>
         </v-list>
         <v-row justify="center">
          <v-btn color="red darken-1" text @click="deleteAllShares()" v-if="owned">Delete All Shares</v-btn>
          <v-btn color="blue darken-1" text @click="addShareDialog = !addShareDialog" v-if="!readonly">Add Share</v-btn>
         </v-row>
        </v-container>
      </v-card-text>

      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="shareDialog = !shareDialog">Close</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <v-dialog
      v-model="addShareDialog"
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

  <v-dialog
      v-model="addListDialog"
      max-width="600px"
  >
    <v-card>
      <v-card-title>Add List</v-card-title>
      <v-card-text>
        <v-container>
         <v-row>
           <v-text-field v-model="addListName" label="List Name" required></v-text-field>
         </v-row>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="doAddListCancel()">Cancel</v-btn>
        <v-btn color="blue darken-1" text @click="doAddList()">Add</v-btn>
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
            <v-btn text color="red" @click="deleteDialog = !deleteDialog" v-if="owned">Delete</v-btn>
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
                    <v-row>
                      <v-btn icon @click="editItem(item)">
                        <v-icon>mdi-pencil</v-icon>
                      </v-btn>
                      <v-btn icon color="red" @click="deleteItem(item)">
                        <v-icon>mdi-delete</v-icon>
                      </v-btn>
                    </v-row>
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
    editDialog: false,
    deleteDialog: false,
    addListDialog: false,
    addListName: null,
    register: false,
		drawer: false,
    login: true,
    showpass: false,
    shareDialog: false,
    token: null,
    password: "",
    username: "",
    loginerror: null,
    registererror: null,
    lists: [],
    selectedList: null,
    content: null,
    itemDialog: false,
    itemAmount: "",
    editItemAmount: "",
    itemName: "",
    editItemName: "",
    shareWith: "",
    shareReadonly: false,
    registration: null,
    selectedItem: null,
    recovery: null,
    recover: false,
    recovererror: null,
    addShareDialog: false,
    shares: [],
	}),
  computed: {
    readonly: function() {
      return this.content?.readonly
    },
    items: function() {
      return this.content?.items
    },
    selectedId: function() {
      if(this.selectedList == null){
        return null
      }
      return this.lists[this.selectedList][1].id
    },
    selectedStatus: function () {
      if(this.selectedList == null){
        return null;
      }
      return this.lists[this.selectedList][1].status
    },
    selectedPublic: function () {
      if(this.selectedList == null){
        return null;
      }
      return this.lists[this.selectedList][1].public
    },
    owned: function () {
      return this.selectedStatus === "owned";
    },
    selectedName: function() {
      if(this.selectedList == null){
        return null
      }
      return this.lists[this.selectedList][0]
    },
  },
  watch: {
    selectedId: async function(list) {
      await this.fetchShares(list);
    },
  },
	created () {
		this.$vuetify.theme.dark = true
    this.ENDPOINT = ENDPOINT
	},
  async mounted() {
    this.registration = new URL(location.href).searchParams.get('registration');
    this.recovery = new URL(location.href).searchParams.get('recovery');
    if (this.recovery != null) {
      const rsp = await fetch(ENDPOINT + "/recover/" + this.recovery, {
        method: "GET",
        headers: {'Content-Type': 'application/json'},
      });

      if(!rsp.ok) {
        console.log(rsp);
        this.error = "An unexpected error occured";
      } else {
        const resp_body = await rsp.json();
        if("ok" in resp_body) {
          this.username = resp_body.ok.username;
        } else {
          this.recovererror = this.errorDesc(resp_body.err);
        }
      }

      this.recover = true;
      this.login = false;
    } else if(this.registration != null) {
      this.register = true;
      this.login = false;
    } else if(localStorage.token) {
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
    fetchShares: async function(list) {
      const rsp = await fetch(ENDPOINT + "/share/" + list, {
        method: "GET",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      });

      if(!rsp.ok) {
        console.log(rsp);
      } else {
        const resp_body = await rsp.json();
        if("ok" in resp_body) {
          this.shares = [];
          const shared_with = resp_body.ok.shared_with;
          for(var i = 0; i < shared_with.length; i++) {
            const [account, readonly] = shared_with[i];
            const nameRsp = await fetch(ENDPOINT + "/account/" + account + "/name", {
              method: "GET",
              headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
            });

            if(!nameRsp.ok) {
              console.log(nameRsp);
            } else {
              const nameRspBody = await nameRsp.json();
              if("ok" in nameRspBody) {
                this.shares.push({"username": nameRspBody.ok.username, "readonly": readonly, "id": account});
              } else {
                console.log(nameRspBody.err);
                this.shares = [];
                return;
              }
            }
          }
        } else {
          console.log(resp_body.err);
        }
      }
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
    doRecover: async function() {
      this.recovererror = null;
      const rsp = await fetch(ENDPOINT + "/recover/" + this.recovery, {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({password: this.password})
      });

      if(!rsp.ok) {
        console.log(rsp);
        this.recovererror = "An unexpected error occured";
      } else {
        const resp_body = await rsp.json();
        if("ok" in resp_body) {
          await this.doLogin();
          this.recovererror = this.loginerror;
          if(this.recovererror == null) {
            this.recover = false;
          }
        } else {
          this.recovererror = this.errorDesc(resp_body.err);
        }
      }
    },
    doRegister: async function() {
      this.registererror = null;
      const regRsp = await fetch(ENDPOINT + "/register/" + this.registration, {
        method: "POST",
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({password: this.password, username: this.username})
      });

      if(!regRsp.ok) {
        console.log(regRsp);
        this.registererror = "An unexpected error occured";
      } else {
        const regResp_body = await regRsp.json();
        if("ok" in regResp_body) {
          await this.doLogin();
          this.registererror = this.loginerror;
          if(this.registererror == null) {
            this.register = false;
          }
        } else {
          this.registererror = this.errorDesc(regResp_body.err);
        }
      }
    },
    addList: function() {
      this.addListDialog = true;
    },
    doAddListCancel() {
      this.addListDialog = false;
      this.addListName = null;
    },
    doAddList: async function() {
      this.addListDialog = false;
      this.selectedList = null;
      const resp = await fetch(ENDPOINT + "/list", {
        method: "POST",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
        body: JSON.stringify({name: this.addListName})
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          this.addListName = "";
          this.fetchLists();
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }
    },
    setPublic: async function() {
      await fetch(ENDPOINT + "/public/" + this.selectedId, {
        method: "PUT",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })
      this.fetchLists();
    },
    removePublic: async function() {
      await fetch(ENDPOINT + "/public/" + this.selectedId, {
        method: "DELETE",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })
      this.fetchLists();
    },
    doDelete: async function() {
      this.deleteDialog = false;
      const resp = await fetch(ENDPOINT + "/list/" + this.selectedId, {
        method: "DELETE",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          this.selectedList = null;
          this.fetchLists();
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
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
    formatShare(share) {
      return share.username + (share.readonly ? " (readonly)" : "")
    },
    formatItem(item) {
      return item.name + (item.amount == null ? "" : ` (${item.amount})`)
    },
    deleteShare: async function(share) {
      const resp = await fetch(ENDPOINT + "/share/" + this.selectedId + "/" + share.id, {
        method: "DELETE",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          await this.fetchShares(this.selectedId);
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }
    },
    deleteAllShares: async function() {
      const resp = await fetch(ENDPOINT + "/share/" + this.selectedId, {
        method: "DELETE",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
      })

      if(!resp.ok) {
        console.log(resp);
        alert("Unexpected error occured");
      } else{
        const resp_body = await resp.json();
        if("ok" in resp_body) {
          await this.fetchShares(this.selectedId);
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }
    },
    formatTitle(item) {
      return `${item[0]} (${item[1].status})`
    },
    editItem(item) {
      this.selectedItem = item;
      this.editItemAmount = item.amount;
      this.editItemName = item.name;
      this.editDialog = true;
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
    doItemEdit: async function() {
      this.editDialog = false;

      const resp = await fetch(ENDPOINT + "/list/" + this.selectedId + "/" + this.selectedItem.id, {
        method: "PATCH",
        headers: {'Content-Type': 'application/json', 'Authorization': `Bearer ${this.token}`},
        body: JSON.stringify({name: this.itemName == "" ? null : this.itemName, amount: this.itemAmount == "" ? null : this.itemAmount})
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
    doItemCancel() {
      this.itemDialog = false;
      this.editDialog = false;
      this.selectedItem = null;
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
      this.addShareDialog = false;
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
          this.addShareDialog = false;
          this.shareWith = "";
          this.shareReadonly = false;
          await this.fetchShares(this.selectedId);
        } else {
          console.log(resp_body);
          alert("Unexpected error occured");
        }
      }

    }
  }
}
</script>
