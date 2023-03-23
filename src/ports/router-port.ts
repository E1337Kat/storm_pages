import type { Ports } from '../types'

class RouterPort {
  ports: Ports
  subscribe(elmAppPorts: Ports): void {
    this.ports = elmAppPorts
    this.attachCallbacks()

    document.addEventListener(
      'visibilitychange',
      () => {
        this.ports.receivePageVisibility.send(
          document.visibilityState !== 'hidden'
        )
      },
      false
    )
  }

  attachCallbacks(): void {
    this.ports.loadUrlInNewTab.subscribe((url: string) =>
      window.open(url, '_blank')
    )


  }
}

export default RouterPort
