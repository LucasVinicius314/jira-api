import * as dotenv from 'dotenv'

import { CommonEntities } from '../typescript/user'
import { DBEntities } from '../services/sequelize'
import { HttpException } from '../exceptions/httpexception'
import { JiraEntities } from '../typescript/entities'
import { axios } from '../services/axios'

dotenv.config()

export class Jira {
  static getHeaders = async (user: CommonEntities.UserAttributes) => {
    const key = await DBEntities.ApiKey.findOne({
      where: {
        userId: user.id,
      },
    })

    if (key == null) throw new HttpException(400, 'Key not found.')

    const credentials = key.key

    const headers = {
      Accept: 'application/json',
      Authorization: `Basic ${Buffer.from(credentials).toString('base64')}`,
    }

    return headers
  }

  static url = async (path: string, user: CommonEntities.UserAttributes) => {
    return `https://${user.projectKey}.atlassian.net/rest/api/3/${path}`
  }

  static events = async (user: CommonEntities.UserAttributes) => {
    return await axios.get(await this.url('events', user))
  }

  static project = async (user: CommonEntities.UserAttributes) => {
    return await axios.get<JiraEntities.Project[]>(
      await this.url('project', user),
      { headers: await this.getHeaders(user) }
    )
  }

  static issue = async ({ summary }: { summary: string }) => {
    return await axios.post(`issue`, {
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
    // fix
    return await axios.get(`issue/${id}`)
  }

  /**
   * https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/#api-rest-api-3-search-get
   */
  static search = async (
    user: CommonEntities.UserAttributes,
    issueTypes: string[] | null
  ) => {
    const projectQuery = `project = ${user.teamKey}`
    const issueTypeQuery =
      issueTypes === null ? null : `issuetype in (${issueTypes.join(',')})`

    const issueTypeQueryAppend =
      issueTypeQuery === null ? '' : `and ${issueTypeQuery}`

    return await axios.get<{
      expand: number
      startAt: number
      maxResults: number
      total: number
      issues: JiraEntities.Issue[]
      warningMessages: string[]
    }>(await this.url('search', user), {
      params: {
        fields: 'summary,description,status,issuetype',
        jql: `${projectQuery} ${issueTypeQueryAppend}`,
      },
      headers: await this.getHeaders(user),
    })
  }
}
