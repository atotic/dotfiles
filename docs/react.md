Jan 11, 2023
Reading React docs
Hooks: https://reactjs.org/docs/hooks-reference.html
React lifecycle diagram: https://projects.wojtekmaj.pl/react-lifecycle-methods-diagram/
Finally, I've found all the hooks!
Hooks are functions that let you “hook into” React state and lifecycle features from function components

useState: 
flushSync: In the rare case that you need to force the DOM update to be applied synchronously, you may wrap it in flushSync. 
useEffect: way to schedule things to run after render
useContext: way to get state without passing in the props.

I have not figured out how to think in react yet.



Jan 10, 2023

# Effects: a post-render lifecycle callback.
useEffect(afterRenderCallback, propsArray)
afterRenderCallback
afterRenderCallback: () => cleanupCallback
propsArray: optional array of properties we get from useState. 
          afterRenderCallback will only get called if properties change.
cleanupCallback: gets called before next effect, and after component unmounts.

Hooks must be called from top level. This can be enforced by eslint plugin.


Dec 24, 2022
How to use babel to import local files?
<script type="text/jsx" src="LongTasks.js" />
It cannot be served over local file system because file:// access is prohibited
by CORS.


Nov 30th
Readings:
Rebuilding twitter today: big picture from an experienced developer
https://paularmstrong.dev/blog/2022/11/28/lessons-learned-how-i-would-rebuild-twitter-today/
- ReactNative for the web is not good
- use solid-js or another non-virtual DOM framework
- solid assumes knowledge of how React works, so I should learn React (yea, I know)
- TailwindCSS: interesing take on CSS. It is like an inline CSS, but
  you are inlining class names instead. They do have nice looking components,
  they are $300.
- Module federation. https://blog.logrocket.com/building-micro-frontends-webpacks-module-federation/
  Some crazy way to split up your SPA into smaller aps.
Node for services?
Express for http

https://www.reaktor.com/blog/how-to-deal-with-life-after-heroku/
Life after Heroku
Advice on how to host your apps today

Nov 28th
Debugging Node scripts:
- start Node with "node --inspect-brk script.cjs"
- load chrome://inspect, and script.cjs will show up.
- finished yimby-alerts, see if they followup with pair programming

Nov 23rd
Working on bare-minimum, compiler free react project.
I wanted to know the cost of unoptimized javascript. 
There was no way to do it outside of DevTools performance tab.
In DevTools performance tab, you can find Javascript under
"Evaluate Script". From JS, the only JS execution performance
you can measure is longtasks. That API will report longtasks,
but does not report what longtask it was.
The recommended way to analyze performance is DevTools.
UserTiming performance extensions can be used 

https://developer.mozilla.org/en-US/docs/Web/API/Performance_API
https://germainux.com/blog/measuring-the-real-time-performance-of-a-web-application-using-only-javascript/


Nov 18th
- react without precompilers. Find an example by reading NextJS docs
https://nextjs.org/learn/foundations/from-javascript-to-react/getting-started-with-react

React17 vs 18
ReactDOM.render vs ReactDOMClient.createRoot() + render()

Nov 16th
Hot Module Replacement: an elaborate framework where file edited 
in development gets replaced in browser. Why? Enables browser to 
keep state.

Interesting: React 17 introduced a new thing: JSX is no longer
compiled to React.createElement. It is now a call to jsx library
that does not require react. 

Nov 15th
https://rollupjs.org/guide/en/
Before ES modules, bundling javascript was complex: you had to bundle into iife.
tree-shaking: prunes unusued code.
Bundles were made for node, and for browser, and they could be in different.

Nov 14th
I need to learn a bit about javascript modules, bundling.

Vite seems to be a cleaner implementation of a react starter project


### React tools

[babel](https://unpkg.com/@babel/standalone/babel.min.js)
- jsx compiler
- <script type="text/jsx">

create-react-app
- official "create new app" from react. Complex setup by default

next.js 
- React framework giving you building blocks to create web applications 


react

create-react-app is an npm module that gives you a preconfigured environment for creating react apps
https://create-react-app.dev/docs/available-scripts

eject removes react-scripts command, and replaces it with to underlying commands: 
webpack, Babel, ESLint. 

If I wanted to build my own license plate reader in the browser

There is one main license plate reading solution:
https://github.com/openalpr/openalpr/blob/master/README.md

There are no clean open-source license plate readers that can be run in the browser
They all operate on the same principle:
- segment the image, find a rectangle with letters in it
- pass the letters through letter recognition library (tesseract)

npm 

my-app:

When you run `npm eject`, about 50 dependencies magically appear, including lots of build scripts.
Size: 231MB for 40,000 files.
webpack, Babel, ESLint


Functional vs class components

Functional components are the future: easier to type,
They are functionally identical.
Functional component uses hooks instead of callbacks.

https://www.twilio.com/blog/react-choose-functional-components

Components API:
- they get props passed in constructor
- they get state (create in constructor, or React.useState hook)
- lifecycle:
  componentDidMount or React.useEffect
  componentWillUnmount or React.useEffect


# TODO

## React animations
- Animate list reordering (fullstack react exercise 2). How to do it? 
- Store old positions, animate from new positions
- React recommends using an animation library like 
https://reactcommunity.org/react-transition-group/

## React for the DOM developer
You know your Javascript, DOM, CSS, and now you need to learn React.
What is interesting about React?

## Vite as a development framework (insted of create-react-app)
https://vitejs.dev/blog/announcing-vite2.html

# Links

https://reactcommunity.org/react-transition-group/

HMR: Hot Module Replacement

