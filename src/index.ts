import type { Ports } from './types'
import './scss/style.scss'
import { Elm } from './Main.elm'
import RouterPort from './ports/router-port'

/**
 * Whether to delay initializing Elm.
 */
const doWaitForLoad = function () {
  return false
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

/**
 * Initialize the app.
 */
async function startApp(waitTime: number) {
  await sleep(waitTime)

  const maybeDoIt: boolean =
    true || null

  const app = Elm.Main.init({
    flags: {
      doIt: maybeDoIt,
    }
  })
  const ports: Ports = app.ports

  const routerPort = new RouterPort()
  routerPort.subscribe(ports)

}

document.addEventListener('DOMContentLoaded', () => {
  const waitTime: number = doWaitForLoad() ? 3000 : 0
  startApp(waitTime)
})
