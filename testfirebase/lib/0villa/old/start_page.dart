import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/models/frase_model.dart';

class StartPage extends StatelessWidget {
  final Function(int) beginGame;

  const StartPage({Key key, this.beginGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yo nunca edicion 0Villa",
              textScaleFactor: 4,
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
              child: Text("LIST ALL"),
              onPressed: () {
                beginGame(1);
              },
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
              child: Text("BEGIN GAME"),
              onPressed: () {
                beginGame(2);
              },
            )
          ],
        ),
      ),
    );
  }

  List<FraseModel> parseFrases() {
    final String frasesRaw = getFrasesRaw();
    final re = RegExp('([0-9]+).');
    final List<String> frasesList = frasesRaw.split("\n");
    return frasesList.map((e) {
      final match = re.stringMatch(e);
      final numero = int.parse(e.substring(0, match.length - 1));
      final frase = e.substring(match.length + 1);
      return FraseModel(frase: frase, numero: numero);
    }).toList();
  }

  String getFrasesRaw() {
    final String frasesRaw = '''1. Yo nunca lo he hecho sin haber querido.
2. Yo nunca lo he hecho con mas de una persona en un mismo dia. 
3. Yo nunca he querido tirarme a la madre/padre de un amigo/a.
4. Yo nunca he querido tirarme al hermano/a de un amigo/a.
5. Yo nunca me he querido liar con alguien presente. 
6. Yo nunca he tenido fantasias sexuales sobre alguien que no considerase atractivo/a. 
7. Yo nunca lo he hecho a pelo.
8. Yo nunca he acabado en la boca de alguien/ me han acabado en la boca. 
9. Yo nunca he querido tirarme al novio/a de un amigo/a. 
10. A mi nunca me han pedido que fuese mas lento porque iba demasiado rapido. 
11. Yo nunca he dejado con las ganas a alguien.
12. A mi nunca me han dejado con las ganas. 
13. Yo nunca he tenido la tipica discusion de "luces encendidas/ apagadas".
14. Yo nunca me he encontrado un pelo en la boca tras hacer oral.
15. Yo nunca he puesto los cuernos. 
16. A mi nunca me han puesto los cuernos.
17. Yo nunca he dudado de mi orientacion sexual.
18. Yo nunca me he liado con dos personas de distinto sexo en una noche.
19. Yo nunca me he liado con alguien y me he arrepentido inmediatamente despues. 
20. Yo nunca he tenido sexo por pena.
21. Yo nunca me he tirado a mi ex. 
22. A mi nunca me han pillado en el acto. 
23. Yo nunca lo he hecho en un lugar publico. 
24. Yo nunca lo he hecho en la cama de una tercera persona.
25. Yo nunca lo he hecho con mas gente al rededor.
26. Yo nunca he hecho un trio.
27. Yo nunca he tenido fantasias sexuales sobre hacer un trio con mi novio/a y otra persona.
28. Yo nunca me he masturbado con un objeto inanimado. 
29. Yo nunca me he hecho daño a mi mismo al masturbarme.
30. Yo nunca me he decepcionado al liarme/tirarme a alguien con quien tenia muchas ganas. 
31. Yo nunca he practicado sadomasoquismo o usado objetos relacionados. 
32. Yo nunca he intentado anal pero no salio bien. 
33. Yo nunca he practicado anal por placer. 
34. Yo nunca me he liado/tirado a alguien que tenia minimo 5 años mas que yo.
35. Yo nunca he hecho algo sexual en el colegio/universidad. 
36. A mi nunca me han hecho un chupeton en un lugar poco comun.
37. Yo nunca he intentado emborrachar a alguien para liarme con esa persona.
38. Yo nunca he visto porno con otra persona.
39. Yo nunca me he grabado con alguien en la cama. 
40. Yo nunca me he masturbado con una pelicula que no fuese pornografica.
41. Yo nunca he tenido un gatillazo.
42. Yo nunca lo he hecho con la regla. 
43. Yo nunca me he querido liar con mas de 2 personas presentes.
44. Yo nunca lo he hecho disfrazado para satisfacer algun morbo.
45. Yo nunca me he liado con el chico/a con quien estaba intentando ligar un amigo/a.
46. Yo nunca me lo he tragado. 
47. Yo nunca me he excitado en un momento muy poco apropiado.
48. A mi nunca se me ha roto el condon. 
49. Yo nunca he estado un año sin sexo tras haberlo hecho previamente.
50. Yo nunca he puesto/a mi nunca me han puesto un condon con la boca.
51. Yo nunca he involucrado comida en el sexo.
52. Yo nunca lo he hecho en una fiesta. 
53. Yo nunca me he tomado/he comprado la pastilla del dia despues.
54. Yo nunca he tenido sexo por telefono.
55. Yo nunca he tenido que correr a buscar mi ropa porque acababan de tocar el timbre de la casa. 
56. Yo nunca he parado de liarme/tirarme a alguien para preguntarle a la persona como se  llamaba.
57. Yo nunca me he liado/tirado a el/la ex de un amigo/a.
58. Yo nunca le he mentido sobre mis experiencias sexuales a mi nueva pareja. 
59. Yo nunca he tenido que enseñar/a mi nunca me han tenido que enseñar como desabrochar un sujetador.
60. Yo nunca he tenido una fantasia sexual sobre un profesor/profesora.
61. Yo nunca he pillado a mis padres haciendolo.
62. Yo nunca me he sacado fotos desnudo/a.
63. Yo nunca he llamado a alguien por un nombre equivocado mientras lo estabamos haciendo. 
64. Yo nunca he/a mi nunca me han lamido el culo.
65. Yo nunca lo he hecho en la ducha.
66. Yo nunca he usado el kamasutra para aprender o involucrar nuevas posiciones en la cama. 
67. Yo nunca lo he hecho con alguien que era virgen.
68. Yo nunca he mentido sobre ser virgen. 
69. Yo nunca me he medido el pene.
70. Yo nunca he borrado conversaciones subidas de tono para que mi pareja no me pillase.
71. Yo nunca me he liado/ tirado a alguien que no me parecia atractivo/a solo porque estaba desesperado/a.
72. Yo nunca he creido haber contraido una enfermedad de transmision sexual.
73. Yo nunca he fingido/exagerado un orgasmo. 
74. Yo nunca he tenido un follamigo/a.
75. Yo nunca he salido de casa sin ropa interior.
76. Yo nunca me he liado/tirado a un extranjero/a.
77. Yo nunca he sentido envidia al ver los genitales de un amigo/a.
78. Yo nunca me he masturbado en casa de un amigo/a. 
79. Yo nunca he hecho/a mi nunca me han hecho una mamada con condon.
80. Yo nunca he usado hielo en la cama.
81. Yo nunca he pedido que satisfacieran un fetiche mio pero sin exito. 
82. Yo nunca he intentado esconder una ereccion en publico sin exito.
83. A mi nunca me ha puesto la violencia en la cama.
84. Yo nunca me he tirado/se han tirado un pedo en el acto.
85. Yo nunca le he roto la ropa a mi pareja al quitarsela.
86. Yo nunca he intentado/querido que una pareja rompiese.
87. Yo nunca he hecho/me han hecho una cubana.
88. Yo nunca me he masturbado viendo hentai.
89. Yo nunca he aceptado hacer algo por dinero.
90. Yo nunca he metido/me han metido mas de 3 dedos. 
91. Yo nunca lo he hecho en un coche y sono la bocina.
92. A mi nunca me han tenido que enseñar una foto de con quien me habia liado porque no me acordaba. 
93. Yo nunca me he depilado los genitales pensando que iba a pinchar y acabe comiendome los mocos. 
94. Yo nunca he querido unirme a dos amigos que estuviesen haciendolo.
95. Yo nunca he hecho una lista de todas los tios/tias con las que me he liado.
96. Yo nunca he conseguido liarme/tirarme a un amor platonico. 
97. Yo nunca he tenido que usar mas de 2 condones en una misma ronda.
98. Yo nunca lo he hecho en todos los cuartos de mi/su casa.
99. Yo nunca he pedido por Chatroulette/Omegle que me enseñen el pene/las tetas.
100. Yo nunca he tenido que usar paginas online o aplicaciones para ligar. 
101. Yo nunca me he dado cuenta de que me estaban mirando mientras lo estaba haciendo.
102. Yo nunca me he liado con alguien presente.
103. Yo nunca me he liado/tirado a alguien que me cayera mal. 
104. A mi nunca se me han/yo nunca he acabado encima del cuerpo.
105. A mi nunca me han dado una hostia por estar tirando la caña.
106. Yo nunca me he arrepentido de con quien habia perdido la virginidad. 
107. Yo nunca me he liado con alguien que acababa de vomitar. 
108. A mi nunca me ha puesto alguien sin saber en su momento que esa persona tenia minimo 4 años menos que yo.
109. Yo nunca he salido con alguien con quien sabia que no iba a estar mucho tiempo.
110. Yo nunca he hecho un 69.
111. Yo nunca lo he hecho con mis/sus padres cerca.
112. Yo nunca he ligado con alguien para poner celoso/a a una persona.
113. Yo nunca me he resbalado mientras lo hacia en la ducha.
114. Yo nunca le he dicho a alguien "te quiero" solo para follar. 
115. Yo nunca he hecho/a mi nunca me han hecho sangrar al meter dedos.
116. Yo nunca he echado un polvo malisimo. 
117. Yo nunca me he masturbado al menos 5 veces en un dia.
118. Yo nunca he tenido un sueño mojado.
119. Yo nunca he pensado que el sexo oral era asqueroso.
120. Yo nunca he pensado que el sexo oral es mejor que la penetracion. 
121. Yo nunca he pensado en otra persona mientras estaba haciendolo con alguien. 
122. Yo nunca lo he hecho con alguien que en mi opinion tenia el pene pequeño.
123. Yo nunca he usado condones con sabores.
124. Yo nunca he/a mi nunca se me han acabado dentro sin condon.
125. Yo nunca me he guardado las fotos de mi ex desnudo/a despues de haber cortado con el/ella. 
126. Yo nunca he usado/nunca han usado conmigo la marcha atras como metodo anticonceptivo.
127. Yo nunca me he liado con alguien que tenia novio/a.
128. A mi nunca me ha tirado la caña un familiar de mi novio/a.
129. Yo nunca he mandado a la friendzone a alguien tras haberme liado con esa persona. 
130. Yo nunca me he alegrado por algo malo que le haya pasado a mi ex.
131. Yo nunca lo he hecho mas de 5 veces en un dia.
132. Yo nunca me he liado con alguien de mi actual clase.
133. A mi nunca me han hecho una cobra de verdad.
134. Yo nunca me he arrepentido de un tatuaje.
135. A mi nunca me ha dado mas morbo hacerlo fuera de casa que dentro. 
136. Yo nunca me he quedado dormido/a durante el sexo.
137. Yo nunca me he pillado por alguien mientras tenia novio/a.
138. Yo nunca he cortado con un novio/a porque el sexo no me satisfacia.
139. Yo nunca he roto la cama al hacerlo.
140. A mi nunca me han llamado la atencion los vecinos por hacer demasiado ruido durante el sexo. 
141. Yo nunca he/a mi nunca me han agarrado del pelo con fuerza en el sexo.
142. Yo nunca he aguantado menos de 10 minutos en la cama. 
143. Nunca han aguantado menos de 10 minutos en la cama conmigo.
144. Yo nunca lo he hecho 3 o mas veces seguidas. 
145. Yo nunca he/a mi nunca me han despertado con una mamada/polvo.
146. Yo nunca me he masturbado mientras hacia una videollamada con alguien.
147. Yo nunca me he creado una cuenta falsa en alguna red social para ver lo que hacia un/a ex sin que se diese cuenta.
148. Yo nunca he conseguido liarme o salir con alguien con quien estaba previamente en la friendzone. 
149. A mi nunca me han pillado un chupeton mis padres.
150. Yo nunca tendria una relacion con alguien presente si se diese el caso. 
151. Yo nunca he visto porno de hermanastros/padrastros/madrastas.
152. Yo nunca he/a mi nunca me han hecho garganta profunda. 
153. Yo nunca me he sentido mal conmigo mismo tras tocarme.
154. Yo nunca le he seguido el rollo a un profesora/a que me estuviese tirando.
155. Yo nunca he pedido hacer un video porno pero sin exito.
156. Yo nunca he fingido ser de otra nacionalidad para ligar.
157. Yo nunca he tenido sexo interracial.
158. Yo nunca he estado frustrado porque no me satisfacia el sexo con una persona a quien queria. 
159. Yo nunca me he masturbado en grupo.
160. Yo nunca me he obsesionado entera o parcialmente con alguien tras liarme con esa persona una vez.
161. Yo nunca he lamido unos pezones.
162. A mi nunca me han lamido los pezones.
163. Yo nunca he estado en la friendzone con alguien presente.
164. Yo nunca he cortado con alguien para salir con otra persona. 
165. Nunca han cortado conmigo para salir con otra persona.
166. Yo nunca lo he hecho estando enfermo.
167. Yo nunca me he querido tirar/tirado a mi mejor amigo/a. 
168. Yo nunca he preferido los culos a las tetas.
169. Yo nunca he tenido pique con el novio/a de mi ex.
170. Yo nunca he pensado que me casaria con un ex o actual pareja.
171. Yo nunca he soñado que me liaba/tiraba a alguien y me he decepcionado al despertarme.
172. Yo nunca me he liado con alguien que tenia muy mal aliento.
173. A mi nunca me han hecho daño al practicar sexo oral.
174. Yo nunca he tenido la paranoia de estar embarazada porque se me habia retrasado la regla.
175. Yo nunca he/a mi nunca me han hecho una mamada conduciendo.
176. Yo nunca le he seguido el rollo a alguien que me estaba tirando solo para conseguir alcohol. 
177. Yo nunca he visto un juguete sexual y he sentido intriga.
178. Yo nunca he tenido un sueño sexual sobre alguien presente/de la clase.
179. Yo nunca he sentido intriga por practicar sexo oral con alguien de mi mismo sexo.
180. Yo nunca he pensado que el sexo entre mismo sexo es o seria mejor que el sexo entre distintos sexos.
181. Yo nunca he sentido atraccion por algun familiar.
182. Yo nunca he chupado un pene/coño que supiera muy mal.
183. A mi nunca me ha interrumpido mi mascota mientras estaba haciendolo.
184. Yo nunca me he/nunca se han equivocado de agujero.
185. Yo nunca me he masturbado justo antes de hacerlo para durar mas. 
186. Yo nunca he usado un video porno como modelo a seguir.
187. Yo nunca me he vestido de cierta forma para atraer la atencion de alguien y paso de mi.
188. Yo nunca he alquilado una habitacion de hotel o motel solo para follar.
189. Yo nunca haria un trio con gente aqui presente.
190. Yo nunca he jugado a algun juego con el castigo de hacer un striptease.
191. Yo nunca me he liado con alguien que besase realmente mal. 
192. Yo nunca he usado el movil mientras lo estaba haciendo.
193. Yo nunca lo he hecho manteniendo 0 contacto visual con la otra persona.
194. A mi nunca me ha tirado para atras ver cuanto pelo pubico tenia la persona con la que lo iba a hacer.
195. Yo nunca me he reido mientras lo estaba haciendo.
196. Yo nunca he tirado la caña de broma y acabo saliendo mejor de lo que esperaba. 
197. Yo nunca me he liado/tirado al mejor amigo/a de mi ex.
198. Yo nunca he me hecho fotos sensuales desnudo/a para enviarselas a alguien.
199. Yo nunca he creido que alguien presente me ha tirado la caña alguna vez.
200. Yo nunca me he liado con alguien que ha querido tener algo conmigo despues sin que yo quisiera.
201. Yo nunca me he liado/tirado a alguien que no he vuelto a ver en mi vida.
202. Yo nunca me he imaginado como serian las tetas/el pene de alguien presente.
203. Yo nunca me habria tirado a alguien de clase principio de curso pero ahora me da asco.
204. Yo nunca he hecho/provocado squirting.
205. Yo nunca he/a mi nunca me han ocasionado moratones o arañazos en el sexo.
206. Yo nunca he/a mi nunca me han dado un pollazo en la cara. 
207. Yo nunca he/a mi nunca me han tirado la caña para conseguir alcohol.
208. Yo nunca lo he hecho con musica de fondo.
209. Yo nunca me he liado/tirado a alguien que estaba muy por encima de mis posibilidades.
210. Yo nunca he tenido una cita de donde creia que podia surgir algo y acabe decepcionandome.
211. A mi nunca me han intentado emborrachar para liarse conmigo.
212. Yo nunca he mentido sobre mi mismo para ligar.
213. Yo nunca lo he hecho estando borracho/fumado.
214. Yo nunca le he robado condones a un familiar.
215. Yo nunca me he llevado condones pensando que iba a pinchar y acabe dandoselos a alguien.
216. Yo nunca he jugado a roles en la cama.
217. Yo nunca he usado saliva como lubricante.
218. Yo nunca me he liado 2 o mas veces con alguien con quien no tenia nada.
219. Yo nunca he negado liarme con alguien pese a ser verdad.
220. Yo nunca he dormido en la misma cama con alguien del sexo opuesto sin que pasara nada.
221. Yo nunca me he liado con mas de 10 personas en toda mi vida.
222. Yo nunca he chantajeado a alguien con contar un secreto suyo.
223. Yo nunca me he enterado de cuernos a un amigo/a y lo he ocultado por alguna razon.
224. Yo nunca he estado mas de un mes sin masturbarme.
225. Yo nunca he pasado de los preliminares y he ido directo/a al sexo.
226. Yo nunca me he quedado en los preliminares porque no me apetecia el sexo.
227. Yo nunca he dejado un polvo a mitad por cualquier razon.
228. Yo nunca me he asustado al ver el tamaño del pene de alguien.
229. Yo nunca me he liado con alguien justo despues de potar.
230. Yo nunca me he dado cuenta de que me estaban mirando mientras meaba.
231. Yo nunca he tenido arcadas al hacer oral.
232. A mi nunca me ha puesto alguien que no considerase atractivo/a.
233. Yo nunca he/a mi nunca me han hecho una mamada bajo el agua.
234. Yo nunca he rechazado a un/una ex que queria volver a liarse conmigo.
235. Yo nunca lo he hecho en otro pais.
236. Yo nunca me he masturbado con una foto.
237. Yo nunca he pensado en una vieja o un animal mientras lo hacia para durar mas.
238. Yo nunca he comprado algo en un sex shop.
239. Yo nunca le he hecho un baile sensual a mi pareja.
240. Yo nunca me he encarado con alguien que estuviese mirando o molestando a mi pareja.
241. A mi nunca me han retado a liarme con alguien.
242. Yo nunca me he masturbado pensando en alguien que no fuese mi pareja en ese momento.
243. Yo nunca me he liado/tirado a alguien a quien le tenia ganas mientras tenia novio/a.
244. Yo nunca lo he hecho sin quitarme la mayoria de la ropa.
245. Yo nunca he tenido un/una ex que se cambio de acera despues de dejarlo conmigo.
246. Yo nunca le he hecho la cobra a alguien que me habia rechazado previamente por venganza.
247. Yo nunca he puesto cachondo/a a alguien con un simple susurro al oido.
248. Yo nunca lo he hecho justo despues de discutir para reconciliarnos.
249. Yo nunca volveria con un/una ex.
250. Yo nunca me volveria a liar con alguien presente.
251. Yo nunca lo he hecho en solo una posicion todo el rato.
252. Yo nunca lo he hecho en al rededor de 10 posiciones.
253. Yo nunca he estado un mes sin hacerlo teniendo pareja.
254. Yo nunca he acabado encima de mi propio cuerpo sin querer.
255. A mi nunca me han puesto tanto que me han hecho temblar.
256. A mi nunca se me ha dormido una parte del cuerpo mientras lo hacia.
257. A mi nunca se me ha perdido algo dentro de alguien/de mi mismo/a.
258. Yo nunca he tenido que parar para preguntar si iba todo bien.
259. A mi nunca me han propuesto un trio seriamente.
260. Yo nunca he archivado un chat porque no queria que mi pareja lo viera pero tampoco queria borrarlo.
261. Yo nunca he negado masturbarme.
262. Yo nunca me he excitado/empalmado cuando me han perreado en una fiesta.
263. A mi nunca me han usado para poner celoso/a a alguien.
264. Yo nunca he estado en la cama con alguien del sexo opuesto pero solo hubo besos.
265. Yo nunca me he rascado los genitales en publico y me han visto.
266. Yo nunca lo he hecho con los calcetines puestos.
267. Yo nunca me he negado a hacerle oral a alguien que me lo habia pedido.
268. Yo nunca me he liado con un chico mas bajito/una chica mas alta que yo.
269. Yo nunca lo he hecho con gafas.
270. Yo nunca me he liado con alguien con quien no deberia haberlo hecho por ir borracho/a.
271. Yo nunca he tenido complejo sobre alguna parte de mi cuerpo.
272. Yo nunca lo he hecho justo antes de dormirme y al despertarme.
273. A mi nunca me ha tirado la caña alguien pensando que era de otra orientacion sexual.
274. Yo nunca he aceptado hacer/que me hicieran algo que no queria solo para follar.
275. Yo nunca he hecho que alguien hiciera algo que no queria con el sexo como recompensa.
276. Yo nunca he recibido fotos de alguien desnudo/a.
277. Yo nunca le he estado mirando las tetas a una chica y me ha pillado de pleno.
278. A mi nunca me ha puesto mas hacerlo sin condon.
279. Yo nunca he acabado y he continuado sin parar.
280. Yo nunca he querido tirarme al hermano/a de mi pareja o de un/a ex.
281. Yo nunca he dejado un mancha en la ropa o en la cama.
282. Yo nunca he sido dominante en la cama.
283. Yo nunca me he masturbado en una ducha que no fuese la mia.
284. Yo nunca le he contado a alguien que habia follado inmediatamente despues de hacerlo.
285. Yo nunca lo he hecho en una bañera.
286. Yo nunca lo he hecho en el suelo.
287. A mi nunca me han visto haciendo cualquier cosa sexual en el cine.
288. Yo nunca he tenido sexo esta ultima semana.
289. Yo nunca me he masturbado hoy.
290. Yo nunca he sudado mucho/bastante durante el sexo.
291. Yo nunca he buscado consejos sexuales en internet.
292. A mi nunca me ha gustado mas estar debajo que encima.
293. A mi nunca me ha gustado mas estar encima que debajo.
294. Yo nunca he salido con alguien a quien no queria.
295. Yo nunca he tenido un amigo/a que se ha liado con mi ex
296. A mi nunca me ha hecho una cobra alguien presente.
297. Yo nunca le he hecho una cobra a alguien presente.
298. Yo nunca me he masturbado en otro pais.
299. Yo nunca me he liado con alguien solo porque un amigo/a me ayudo.
300. Yo nunca pense que podria tener algo con alguien presente/de mi actual clase sin darme cuenta de que no le atraia para nada.
301. Yo nunca me he masturbado con amigo/as en casa.
302. Yo nunca me he masturbado pensando en alguien menor que yo.
303. Yo nunca he tonteado/ligado con alguien con quien no tenia ningun interes en quedar.
304. Yo nunca me he pillado por alguien con quien no podria tener nada por su orientacion sexual.
305. Yo nunca he pensado que alguien presente podia ser una fiera en la cama.
306. Yo nunca he vuelto con un/una ex.
307. Yo nunca me he liado/he salido con alguien con quien habia previamente negado que tendria algo jamas.
308. Yo nunca me he arrepentido de liarme con/pillarme por alguien presente.
309. Yo nunca me he puesto la ropa interior de alguien del sexo opuesto.
310. Yo nunca he acabado al mismo tiempo que la persona con quien lo estaba haciendo.
311. Yo nunca lo he hecho en una cama individual.
312. Yo nunca lo he hecho en un sofa.
313. Yo nunca he usado lubricante de sabores.
314. Yo nunca he dejado que alguien usara un juguete sexual conmigo.
315. A mi nunca me ha puesto hacer oral.
316. A mi nunca me ha oido haciendolo un amigo/a.
317. Yo nunca he oido a un amigo/a haciendolo.
318. Yo nunca he dejado manchas en la pared.
319. Yo nunca me he mirado en el espejo mientras lo estaba haciendo.
320. Yo nunca me he negado a hacerlo con mi pareja pese a que me lo suplicara.
321. Yo nunca les he contado a mis padres que perdi la virginidad.
322. Yo nunca he dicho que no podia ir a alguna quedada por quedarme follando.
323. Yo nunca me he puesto celoso al ver a mi pareja hablar con su ex.
324. Yo nunca he sido sumiso/a.
325. Yo nunca he pensado en operarme las tetas. 
326. A mi nunca se me ha salido en pleno acto y me he hecho daño. 
327. Yo nunca he hecho algo que previamente pense que nunca haria.
328. Yo nunca he/a mi nunca me han hecho el hamster.
329. Yo nunca he perdido la virginidad con 15 años o menos.
330. Yo nunca he desvirgado a alguien menor de 16 años.
331. Yo nunca he rendido poco en algun deporte porque acababa de hacerlo.
332. Yo nunca me he puesto el condon al reves.
333. Yo nunca he usado lubricantes con efectos de calor o frio.
334. Yo nunca me he puesto un condon que me fuera incomodamente pequeño o apretado.
335. Yo nunca me he masturbado con un condon puesto.
336. Yo nunca lo he hecho con los ojos tapados por algo.
337. Yo nunca he perdido el equilibrio mientras lo hacia.
338. Yo nunca he pensado que alguien presente podria salir del armario.
339. Yo nunca estuve a punto de liarme con alguien hasta que otra persona me interrumpio.
340. Yo nunca he entrado en un puticlub.
341. Yo nunca he querido entrar en un puticlub pero por una razon u otra no lo hice.
342. Yo nunca enviado/recibido fotos desnudas por accidente.
343. A mi nunca me ha puesto mas hacerlo con los padres cerca.
344. Yo nunca he tenido que asegurarme de hacerlo en silencio para que no nos oyeran los padres.
345. Yo nunca lo he hecho en una posicion que no me gustara solo porque mi pareja queria.
346. Yo nunca he sido incapaz de recrear una posicion de kamasutra. 
347. Yo nunca me he liado/tirado o tenido algo con alguien para olvidarme de otra persona.
348. A mi nunca me ha tirado la caña un familiar de un amigo/a.
349. Yo nunca he pensado que, por ejemplo, (persona presente) y (persona presente) podrian liarse. 
350. Yo nunca he mentido en este Yo Nunca.''';

    return frasesRaw;
  }
}
