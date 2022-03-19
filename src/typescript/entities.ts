export namespace Entities.Jira {
  export type Project = {
    self: string
    id: string
    key: string
    name: string
    avatarUrls: {
      '48x48': string
      '24x24': string
      '16x16': string
      '32x32': string
    }
    projectCategory: {
      self: string
      id: string
      name: string
      description: string
    }
    simplified: boolean
    style: string
    insight: {
      totalIssueCount: number
      lastIssueUpdateTime: string
    }
  }

  export type Issue = {
    expand: string
    id: string
    self: string
    key: string
    fields: {
      watcher: {
        self: string
        isWatching: boolean
        watchCount: number
        watchers: [
          {
            self: string
            accountId: string
            displayName: string
            active: boolean
          }
        ]
      }
      attachment: Attachment[]
      'sub-tasks': [
        {
          id: '10000'
          type: {
            id: '10000'
            name: ''
            inward: 'Parent'
            outward: 'Sub-task'
          }
          outwardIssue: {
            id: '10003'
            key: 'ED-2'
            self: 'https://your-domain.atlassian.net/rest/api/3/issue/ED-2'
            fields: {
              status: {
                iconUrl: 'https://your-domain.atlassian.net/images/icons/statuses/open.png'
                name: 'Open'
              }
            }
          }
        }
      ]
      /**
       * {
       *  "type": "doc",
       *  "version": 1,
       *  "content": [
       *    {
       *      "type": "paragraph",
       *      "content": [
       *        {
       *          "type": "text",
       *          "text": "Main order flow broken"
       *        }
       *      ]
       *    }
       *  ]
       * }
       */
      description: {
        type: string
        version: number
        content: [
          {
            type: string
            content: [
              {
                type: string
                text: string
              }
            ]
          }
        ]
      }
      project: Project
      comment: [
        {
          self: 'https://your-domain.atlassian.net/rest/api/3/issue/10010/comment/10000'
          id: '10000'
          author: {
            self: 'https://your-domain.atlassian.net/rest/api/3/user?accountId=5b10a2844c20165700ede21g'
            accountId: '5b10a2844c20165700ede21g'
            displayName: 'Mia Krystof'
            active: false
          }
          body: {
            type: 'doc'
            version: 1
            content: [
              {
                type: 'paragraph'
                content: [
                  {
                    type: 'text'
                    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eget venenatis elit. Duis eu justo eget augue iaculis fermentum. Sed semper quam laoreet nisi egestas at posuere augue semper.'
                  }
                ]
              }
            ]
          }
          updateAuthor: {
            self: 'https://your-domain.atlassian.net/rest/api/3/user?accountId=5b10a2844c20165700ede21g'
            accountId: '5b10a2844c20165700ede21g'
            displayName: 'Mia Krystof'
            active: false
          }
          created: '2021-01-17T12:34:00.000+0000'
          updated: '2021-01-18T23:45:00.000+0000'
          visibility: {
            type: 'role'
            value: 'Administrators'
          }
        }
      ]
      issuelinks: [
        {
          id: '10001'
          type: {
            id: '10000'
            name: 'Dependent'
            inward: 'depends on'
            outward: 'is depended by'
          }
          outwardIssue: {
            id: '10004L'
            key: 'PR-2'
            self: 'https://your-domain.atlassian.net/rest/api/3/issue/PR-2'
            fields: {
              status: {
                iconUrl: 'https://your-domain.atlassian.net/images/icons/statuses/open.png'
                name: 'Open'
              }
            }
          }
        },
        {
          id: '10002'
          type: {
            id: '10000'
            name: 'Dependent'
            inward: 'depends on'
            outward: 'is depended by'
          }
          inwardIssue: {
            id: '10004'
            key: 'PR-3'
            self: 'https://your-domain.atlassian.net/rest/api/3/issue/PR-3'
            fields: {
              status: {
                iconUrl: 'https://your-domain.atlassian.net/images/icons/statuses/open.png'
                name: 'Open'
              }
            }
          }
        }
      ]
      worklog: Worklog[]
      updated: number
      timetracking: {
        originalEstimate: string
        remainingEstimate: string
        timeSpent: string
        originalEstimateSeconds: number
        remainingEstimateSeconds: number
        timeSpentSeconds: number
      }
    }
  }

  export type Attachment = {
    id: number
    self: string
    filename: string
    author: {
      self: string
      key: string
      accountId: string
      accountType: string
      name: string
      avatarUrls: {
        '48x48': string
        '24x24': string
        '16x16': string
        '32x32': string
      }
      displayName: string
      active: boolean
    }
    created: string
    size: number
    mimeType: string
    content: string
    thumbnail: string
  }

  export type Worklog = {
    self: string
    author: {
      self: string
      accountId: string
      displayName: string
      active: boolean
    }
    updateAuthor: {
      self: string
      accountId: string
      displayName: string
      active: boolean
    }
    comment: {
      type: string
      version: number
      content: [
        {
          type: string
          content: [
            {
              type: string
              text: string
            }
          ]
        }
      ]
    }
    updated: string
    visibility: {
      type: string
      value: string
      identifier: string
    }
    started: string
    timeSpent: string
    timeSpentSeconds: number
    id: string
    issueId: string
  }
}
