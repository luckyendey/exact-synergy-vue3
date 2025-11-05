# LinkedIn Post: Building Modern UI in Exact Synergy Enterprise with Vue 3 + Element Plus

---

## **How to Embed Vue 3 into Exact Synergy Enterprise**

Exact Synergy Enterprise's native UI is quite dated compared to modern web standards. In this tutorial, I'll show you how to embed modern JavaScript frameworks into it to create better user experiences.

Follow this step-by-step guide to embed Vue 3 + Element Plus UI framework directly into Exact Synergy Enterprise and build a modern employee directory interface!

## What You'll Build
A responsive, professional employee card grid with:
- Beautiful gradient avatars with initials fallback
- Smooth hover animations
- Clean, modern design
- Real-time data from the database


![Employee Directory Preview](misc/images/preview.gif)

*Preview of the employee directory interface built with Vue 3 + Element Plus in Exact Synergy Enterprise*


## Step-by-Step Implementation Guide

### Step 1: Create the Main Page

Create a new page named `CustomPeopleCard.aspx` in your Exact Synergy `docs` folder. This will host the Vue app and the Element Plus UI. We'll wire up resources, structure, and logic in the next steps.

### Step 2: Reference Required Files

Place these files in your `docs` folder and reference them in the page:
- `vue-3.5.22.js` — Vue 3 framework (local file)
- `element-plus.js` — Element Plus UI library (local file)
- `element-plus.css` — Element Plus styling (local file)

Add these to your page head/footer:
```html
<!-- Import CSS -->
<link href="Exact.css" type="text/css" rel="stylesheet" />
<link href="element-plus.css" type="text/css" rel="stylesheet" />

<!-- Import Scripts -->
<script src="vue-3.5.22.js"></script>
<script src="element-plus.js"></script>
<script src="https://unpkg.com/@element-plus/icons-vue"></script>
```

Note: Vue and Element Plus are loaded as local files; Element Plus icons are loaded from CDN.

### Step 3: Create the Structure for the Main Page

Add the Vue app template and Element Plus components inside your page body:
```html
<div id="app" style="clear: left;" v-cloak>
  <div class="people-container">
    <div class="page-header">
      <div>
        <h1 class="page-title">Team Members</h1>
        <div class="employee-count">{{ employees.length }} employees</div>
      </div>
      <el-button type="primary" :icon="Plus" @click="addEmployee">Add Employee</el-button>
    </div>
    
    <el-skeleton v-if="loading" :rows="6" animated></el-skeleton>
    <div v-else class="people-grid">
      <el-card v-for="person in employees" :key="person.employeeId" shadow="hover" class="person-card" @click="navigateToEmployee(person.employeeId)">
        <div class="avatar-container">
          <el-avatar v-if="hasValidPicture(person)" :src="person.picture" :size="80" class="person-avatar"></el-avatar>
          <el-avatar v-else :size="80" class="person-avatar-initials">
            {{ getInitials(person.employeeName) }}
          </el-avatar>
        </div>
        
        <h3 class="person-name">{{ person.employeeName }}</h3>
        <div class="person-title">{{ person.jobTitle }}</div>
        
        <div style="margin-top: 16px;">
          <div class="info-item">
            <el-icon class="info-icon"><component :is="Message" /></el-icon>
            <span class="info-text">{{ person.email }}</span>
          </div>
          
          <div class="info-item">
            <el-icon class="info-icon"><component :is="Calendar" /></el-icon>
            <span class="info-text">{{ formatDate(person.joinDate) }}</span>
          </div>
        </div>
      </el-card>
    </div>
  </div>
  
</div>
```

Add styling to the page head (or a CSS file) to complete the UI:
```css
/* Hide Vue templates until ready */
[v-cloak] { display: none !important; }

/* Layout */
.people-container { padding: 20px; background: #f0f2f5; }
.people-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 24px; margin-top: 30px; }

/* Card */
.person-card { cursor: pointer; transition: all 0.3s ease; text-align: center; border-radius: 16px; background: #fff; }
.person-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12); }
.person-name { color: #1f2937; font-size: 18px; font-weight: 700; margin: 0 0 4px; line-height: 1.4; }
.person-title { color: #6b7280; font-size: 13px; margin: 0 0 16px; font-weight: 400; line-height: 1.4; }

/* Avatar */
.avatar-container { display: flex; justify-content: center; margin-bottom: 16px; }
.person-avatar, .person-avatar-initials { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.person-avatar-initials { background: linear-gradient(135deg, #0F7CBE 0%, #6ED0F6 100%) !important; font-size: 36px; font-weight: 700; color: #fff; }

/* Info */
.info-item { display: flex; align-items: center; justify-content: center; margin-bottom: 8px; font-size: 12px; color: #6b7280; }
.info-item:last-child { margin-bottom: 0; }
.info-icon { margin-right: 6px; color: #0f7cbe; font-size: 14px; }
.info-text { color: #374151; }

/* Header */
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.page-title { font-size: 28px; font-weight: 700; color: #1f2937; margin: 0; }
.employee-count { color: #6b7280; font-size: 14px; margin-top: 4px; }
```

### Step 4: Implement Vue.js Logic

```javascript
const { createApp, markRaw } = Vue;

const app = createApp({
  data() {
    return {
      Plus: markRaw(ElementPlusIconsVue.Plus),
      Calendar: markRaw(ElementPlusIconsVue.Calendar),
      Message: markRaw(ElementPlusIconsVue.Message),
      employees: [],
      loading: true
    };
  },
  methods: {
    hasValidPicture(person) {
      return person.picture && person.picture.length > 0 && person.picture.startsWith('data:image');
    },
    getInitials(name) {
      if (!name) return '??';
      const words = name.trim().split(/\s+/);
      if (words.length === 1) return words[0].substring(0, 2).toUpperCase();
      return (words[0].charAt(0) + words[words.length - 1].charAt(0)).toUpperCase();
    },
    formatDate(dateString) {
      if (!dateString) return 'N/A';
      const date = new Date(dateString);
      return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
    },
    loadEmployees() {
      this.loading = true;
      const url = 'CustomPeopleCardCallback.aspx?Action=1';
      const self = this;
      $.ajax({
        type: 'GET', url, dataType: 'json',
        success(response) {
          if (response.success) {
            self.employees = response.data;
            ElementPlus.ElMessage({ message: 'Employees loaded successfully', type: 'success', duration: 2000 });
          } else {
            ElementPlus.ElMessage({ message: 'Failed to load employees: ' + response.message, type: 'error', duration: 3000 });
          }
          self.loading = false;
        },
        error(xhr, status, error) {
          console.error('Error:', error);
          console.error('Response Text:', xhr.responseText);
          ElementPlus.ElMessage({ message: 'Failed to retrieve data: ' + error, type: 'error', duration: 3000 });
          self.loading = false;
        }
      });
    },
    navigateToEmployee(employeeId) { window.location.href = 'HRMResourceCard.aspx?ID=' + employeeId; },
    addEmployee() { window.location.href = 'HRMResource.aspx?BCAction=0'; }
  },
  mounted() { this.loadEmployees(); }
});

app.use(ElementPlus);
for (const [key, component] of Object.entries(ElementPlusIconsVue)) app.component(key, component);
app.mount('#app');
```

Notes:
- Use `var self = this` (or `const self = this`) inside jQuery callbacks to preserve Vue context.
- Element Plus `ElMessage` is used for success/error notifications.
- Card click navigates to `HRMResourceCard.aspx?ID={employeeId}`; the Add button to `HRMResource.aspx?BCAction=0`.

### Step 5: Create the Callback Page

Create `CustomPeopleCardCallback.aspx` to fetch employee data from the database:

```csharp
private void Page_Load()
{
    try
    {
        var action = Convert.ToInt16(Action.Value);
        switch (action)
        {
            case 1:
            {
                // Get employees data using QueryBuilder
                QueryBuilder qb = new QueryBuilder(conn);
                qb.AppendSelect(@"
                    res_id employeeId,
                    fullname employeeName,
                    jt.descr50 jobTitle,
                    mail email,
                    ldatindienst joinDate,
                    Picture picture
                ");
                qb.AppendFrom("humres h");
                qb.AppendFrom(JoinType.Inner, "hrjbtl jt", "h.job_title = jt.job_title");
                qb.AppendWhere("res_id", Operators.GreaterThan, 0);

                DataSet ds = (DataSet)conn.Query(qb, null, EDLQueryOptions.DataSet);
                DataTable dt = ds.Tables[0];

                var employees = new List<object>();
                foreach (DataRow row in dt.Rows)
                {
                    string pictureUrl = null;
                    if (row["picture"] != DBNull.Value && row["picture"] != null)
                    {
                        byte[] imageBytes = row["picture"] as byte[];
                        if (imageBytes != null && imageBytes.Length > 0)
                        {
                            string base64String = Convert.ToBase64String(imageBytes);
                            pictureUrl = "data:image/jpeg;base64," + base64String;
                        }
                    }
                    employees.Add(new
                    {
                        employeeId = row["employeeId"],
                        employeeName = row["employeeName"],
                        jobTitle = row["jobTitle"],
                        email = row["email"],
                        joinDate = row["joinDate"] != DBNull.Value ? Convert.ToDateTime(row["joinDate"]).ToString("yyyy-MM-dd") : null,
                        picture = pictureUrl
                    });
                }

                WriteResponse(new { success = true, data = employees });
                break;
            }
            default:
                WriteResponse(new { success = false, message = "Invalid action" }, 400);
                break;
        }
    }
    catch (Exception ex)
    {
        WriteResponse(ex, 400);
    }
}

private void WriteResponse(object obj, int statusCode = 200)
{
    var settings = new JsonSerializerSettings { Formatting = Formatting.None };
    Response.Clear();
    Response.ContentType = "application/json; charset=utf-8";
    Response.StatusCode = statusCode;
    Response.Write(JsonConvert.SerializeObject(obj, settings));
    HttpContext.Current.Response.Flush();
    HttpContext.Current.Response.SuppressContent = true;
    HttpContext.Current.ApplicationInstance.CompleteRequest();
}
```

What this does:
- Joins `humres` and `hrjbtl` tables via QueryBuilder
- Converts `byte[]` pictures to base64 data URIs (`data:image/jpeg;base64,....`)
- Returns `{ success: true, data: [...] }` JSON or an error with status 400
- Uses Newtonsoft.Json for serialization

## 📦 Get the Complete Code

All source files are available on GitHub:

🔗 **Repository**: [https://github.com/luckyendey/exact-synergy-vue3](https://github.com/luckyendey/exact-synergy-vue3)

The repository includes:
- `CustomPeopleCard.aspx` - Main Vue 3 page with complete implementation
- `CustomPeopleCardCallback.aspx` - Backend callback for data fetching
- `vue-3.5.22.js` - Vue 3 framework file
- `element-plus.js` - Element Plus UI library
- `element-plus.css` - Element Plus styling
- Complete documentation and setup instructions

⭐ **Star the repo** if you find it helpful!

## 🚀 Ready to Implement?

Follow these steps to implement this solution in your environment:

1. **Clone Repository** - Clone or download the files from GitHub
2. **Prepare Files** - Place Vue 3 and Element Plus files in your `docs` folder
3. **Create Callback** - Build the callback page to fetch data from your database
4. **Build Main Page** - Create the main page with Vue app initialization
5. **Prevent Flash** - Add `v-cloak` directive to prevent template flash
6. **Optimize Performance** - Use `markRaw()` for icon components
7. **Customize Design** - Adjust the styling to match your brand guidelines

## 💡 Key Takeaways

This tutorial demonstrates how modern JavaScript frameworks can breathe new life into Exact Synergy Enterprise. By following these steps, you can:
- Create professional, responsive UIs in Exact Synergy
- Leverage Vue 3's reactive data binding
- Use Element Plus components for consistent design
- Handle images gracefully with fallback avatars
- Implement smooth user interactions

Have questions about implementing this in your environment? Drop a comment below, and I'll be happy to help!

---

#ExactSynergy #VueJS #ElementPlus #WebDevelopment #ModernUI #ERP #JavaScript #DotNet #UIDesign #FrontendDevelopment #EnterpriseApps #SoftwareDevelopment #Coding

---

## 🔍 Key Technical Details

**Callback Pattern:**
- Uses `Action` parameter to switch between different operations
- Returns structured JSON: `{ success: true/false, data: [...], message: "..." }`
- Proper HTTP status codes (200 for success, 400 for errors)

**Vue Integration:**
- `v-cloak` prevents flash of uncompiled content
- `markRaw()` optimizes performance for static icon objects
- Dynamic component binding with `:is="iconName"`
- Conditional rendering with `v-if` and `v-else`
- List rendering with `v-for` and `:key`

**Data Flow:**
1. Vue app mounts and calls `loadEmployees()`
2. jQuery AJAX GET request to callback with `Action=1`
3. Callback queries database via QueryBuilder
4. Converts byte[] pictures to base64 strings
5. Returns JSON response
6. Vue updates reactive data (`employees` array)

## 🔗 Framework Resources

**Vue 3 Official Documentation:**
- [Vue 3 Official Website](https://vuejs.org/)
- [Vue 3 Guide and API Reference](https://vuejs.org/guide/)

**Element Plus UI Framework:**
- [Element Plus Official Website](https://element-plus.org/)
- [Element Plus Icons Library](https://element-plus.org/en-US/component/icon.html)
