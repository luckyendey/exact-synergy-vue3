<%@ Page Language="C#" %>

<%@ Import Namespace="Exact.Data" %>
<%@ Import Namespace="Exact.Core" %>
<%@ Import Namespace="Exact.Common" %>

<script runat="server">
    protected override void OnInit(EventArgs e)
    {
        this.AppUserLicenseType = UserLicenseType.CRM;

        base.OnInit(e);
    }

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        hdr.Caption = "Exact Synergy - Vue 3 + Element Plus UI";
    }
</script>

<html>

<head>
  <meta name="save" content="history" />
  <title></title>
  <link href="Exact.css" type="text/css" rel="stylesheet" />
  <!-- import CSS -->
  <link href="element-plus.css" type="text/css" rel="stylesheet" />
  <style>
    [v-cloak] {
      display: none !important;
    }
    
    .people-container {
      padding: 20px;
      background: #f0f2f5;
    }
    
    .people-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 24px;
      margin-top: 30px;
    }
    
    .person-card {
      cursor: pointer;
      transition: all 0.3s ease !important;
      text-align: center;
      border-radius: 16px !important;
      background: #ffffff !important;
    }
    
    .person-card:hover {
      transform: translateY(-4px) !important;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12) !important;
    }
    
    .person-card .el-card__body {
      padding: 40px 24px 24px !important;
    }
    
    .avatar-container {
      display: flex;
      justify-content: center;
      margin-bottom: 16px;
    }
    
    .person-avatar,
    .person-avatar-initials {
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
    }
    
    .person-avatar-initials {
      background: linear-gradient(135deg, #0F7CBE 0%, #6ED0F6 100%) !important;
      font-size: 36px !important;
      font-weight: 700 !important;
      color: white !important;
    }
    
    .person-name {
      color: #1f2937;
      font-size: 18px;
      font-weight: 700;
      margin: 0 0 4px 0;
      line-height: 1.4;
    }
    
    .person-title {
      color: #6b7280;
      font-size: 13px;
      margin: 0 0 16px 0;
      font-weight: 400;
      line-height: 1.4;
    }
    
    .card-description {
      color: #6b7280;
      font-size: 13px;
      line-height: 1.6;
      margin: 12px 0;
      padding: 0 8px;
      min-height: 60px;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    
    .info-item {
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 8px;
      font-size: 12px;
      color: #6b7280;
    }
    
    .info-item:last-child {
      margin-bottom: 0;
    }
    
    .info-icon {
      margin-right: 6px;
      color: #0f7cbe;
      font-size: 14px;
    }
    
    .info-text {
      color: #374151;
    }
    
    .page-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }
    
    .page-title {
      font-size: 28px;
      font-weight: 700;
      color: #1f2937;
      margin: 0;
    }
    
    .employee-count {
      color: #6b7280;
      font-size: 14px;
      margin-top: 4px;
    }
  </style>
</head>

<body>
  <form runat="server" id="frm">
    <ex:Header runat="server" ID="hdr" Caption="Header">
      <ex:HeaderButton ID="hbFavorite" ButtonStyle="Favorite" />
    </ex:Header>
    <ex:ButtonBar runat="server" ID="buttons">
      <ex:Button runat="server" ID="btnClose" ButtonStyle="Close"></ex:Button>
    </ex:ButtonBar>
    <ex:InputField runat="server" ID="Action" Visible="false" />
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
  </form>
</body>
</html>

<%-- import vue Framework --%>
<script src="vue-3.5.22.js"></script>
<!-- import JavaScript -->
<script src="element-plus.js"></script>
<!-- import Element Plus Icons -->
<script src="https://unpkg.com/@element-plus/icons-vue"></script>

<script type="text/javascript">
  const { createApp, markRaw } = Vue

    const app = createApp({
      data() {
        return {
            Plus: markRaw(ElementPlusIconsVue.Plus), // Mark an object as raw (non-reactive)
            Calendar: markRaw(ElementPlusIconsVue.Calendar), // Mark an object as raw (non-reactive)
            Message: markRaw(ElementPlusIconsVue.Message), // Mark an object as raw (non-reactive)
            Postcard: markRaw(ElementPlusIconsVue.Postcard), // Mark an object as raw (non-reactive)
            employees: [],
            loading: true
        }
      },
      methods: {
        hasValidPicture(person) {
          return person.picture && 
                 person.picture !== null && 
                 person.picture.length > 0 && 
                 person.picture.startsWith('data:image');
        },
        getInitials(name) {
          if (!name) return '??';
          const words = name.trim().split(/\s+/);
          if (words.length === 1) {
            return words[0].substring(0, 2).toUpperCase();
          }
          return (words[0].charAt(0) + words[words.length - 1].charAt(0)).toUpperCase();
        },
        formatDate(dateString) {
          if (!dateString) return 'N/A';
          const date = new Date(dateString);
          return date.toLocaleDateString('en-US', { 
            year: 'numeric', 
            month: 'short', 
            day: 'numeric' 
          });
        },
        navigateToEmployee(employeeId) {
          window.location.href = 'HRMResourceCard.aspx?ID=' + employeeId;
        },
        addEmployee() {
          window.location.href = 'HRMResource.aspx?BCAction=0';
        },
        loadEmployees() {
          this.loading = true;
          var url = 'CustomPeopleCardCallback.aspx?Action=1';
          var self = this;

          $.ajax({
              type: "GET",
              url: url,
              dataType: 'json',
              success: function (response) {
                  if (response.success) {
                      self.employees = response.data;
                      ElementPlus.ElMessage({
                          message: 'Employees loaded successfully',
                          type: 'success',
                          duration: 2000
                      });
                  } else {
                      ElementPlus.ElMessage({
                          message: 'Failed to load employees: ' + response.message,
                          type: 'error',
                          duration: 3000
                      });
                  }
                  self.loading = false;
              },
              error: function (xhr, status, error) {
                  console.error('Error:', error);
                  console.error('Response Text:', xhr.responseText);
                  ElementPlus.ElMessage({
                      message: 'Failed to retrieve data: ' + error,
                      type: 'error',
                      duration: 3000
                  });
                  self.loading = false;
              }
          });
        }
      },
      mounted() {
        this.loadEmployees();
      }
    })
    
    app.use(ElementPlus)
    
    // Register icons
    for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
      app.component(key, component)
    }
    
    app.mount('#app')
</script>