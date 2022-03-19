import * as dotenv from 'dotenv'

import { Entities } from '../typescript/entities'
import { axios } from '../services/axios'

dotenv.config()

const jiraUrl = process.env['JIRA_URL']

const url = `https://${jiraUrl}.atlassian.net/rest/api/3/`

export class Jira {
  static events = async () => {
    return await axios.get(`${url}events`)
  }

  static project = async () => {
    return await axios.get<Entities.Jira.Project[]>(`${url}project`)
  }

  static issue = async ({ summary }: { summary: string }) => {
    return await axios.post(`${url}issue`, {
      fields: {
        summary: summary,
        // parent: {
        //   key: 'PROJ-123',
        // },
        // issuetype: {
        //   id: '10000',
        // },
        // components: [
        //   {
        //     id: '10000',
        //   },
        // ],
        // customfield_20000: '06/Jul/19 3:25 PM',
        // customfield_40000: {
        //   type: 'doc',
        //   version: 1,
        //   content: [
        //     {
        //       type: 'paragraph',
        //       content: [
        //         {
        //           text: 'Occurs on all orders',
        //           type: 'text',
        //         },
        //       ],
        //     },
        //   ],
        // },
        // customfield_70000: ['jira-administrators', 'jira-software-users'],
        // project: {
        //   id: '10000',
        // },
        // description: {
        //   type: 'doc',
        //   version: 1,
        //   content: [
        //     {
        //       type: 'paragraph',
        //       content: [
        //         {
        //           text: 'Order entry fails when selecting supplier.',
        //           type: 'text',
        //         },
        //       ],
        //     },
        //   ],
        // },
        // reporter: {
        //   id: '5b10a2844c20165700ede21g',
        // },
        // fixVersions: [
        //   {
        //     id: '10001',
        //   },
        // ],
        // customfield_10000: '09/Jun/19',
        // priority: {
        //   id: '20000',
        // },
        // labels: ['bugfix', 'blitz_test'],
        // timetracking: {
        //   remainingEstimate: '5',
        //   originalEstimate: '10',
        // },
        // customfield_30000: ['10000', '10002'],
        // customfield_80000: {
        //   value: 'red',
        // },
        // security: {
        //   id: '10000',
        // },
        // environment: {
        //   type: 'doc',
        //   version: 1,
        //   content: [
        //     {
        //       type: 'paragraph',
        //       content: [
        //         {
        //           text: 'UAT',
        //           type: 'text',
        //         },
        //       ],
        //     },
        //   ],
        // },
        // versions: [
        //   {
        //     id: '10000',
        //   },
        // ],
        // duedate: '2019-05-11',
        // customfield_60000: 'jira-software-users',
        // customfield_50000: {
        //   type: 'doc',
        //   version: 1,
        //   content: [
        //     {
        //       type: 'paragraph',
        //       content: [
        //         {
        //           text: 'Could impact day-to-day work.',
        //           type: 'text',
        //         },
        //       ],
        //     },
        //   ],
        // },
        // assignee: {
        //   id: '5b109f2e9729b51b54dc274d',
        // },
      },
    })
  }

  static getIssue = async ({ id }: { id: string }) => {
    return await axios.get(`${url}issue/${id}`)
  }

  /**
   * https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/#api-rest-api-3-search-get
   */
  static search = async () => {
    return await axios.get<{
      expand: number
      startAt: number
      maxResults: number
      total: number
      issues: Entities.Jira.Issue[]
      warningMessages: string[]
    }>(`${url}search`)
  }
}
