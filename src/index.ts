import type { Ports } from './types'
import './scss/style.scss'
import { Elm } from './Main.elm'
import RouterPort from './ports/router-port'

// if (process.env.NODE_ENV !== 'production') {
//   import('elm-debug-transformer').then((lib) =>
//     lib.register({ simple_mode: true, debug: true, limit: 10000 })
//   )
// }

const initialSeedList = Array.from(crypto.getRandomValues(new Uint32Array(4)))

interface Seeds {
  seed1: number
  seed2: number
  seed3: number
  seed4: number
}

const seeds = {
  seed1: initialSeedList[0],
  seed2: initialSeedList[1],
  seed3: initialSeedList[2],
  seed4: initialSeedList[3]
} as Seeds

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
  // const app = Elm.Main.init(1)
  const ports: Ports = app.ports

  const routerPort = new RouterPort()
  routerPort.subscribe(ports)

  // window.setTimeout(() => {
  //   window.monitor = new RTCMonitor(ports)
  // }, 100)
}

document.addEventListener('DOMContentLoaded', () => {
  const waitTime: number = doWaitForLoad() ? 3000 : 0
  startApp(waitTime)
})
