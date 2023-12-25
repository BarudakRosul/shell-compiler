#!/bin/bash
#
# Author: Achixz (Citra Bella Rahayu)
# GitHub: https://github.com/Achixz
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5JΧ�"���*f�A-�˻"��Lϒ��)c_kǂ�ݻ�o�-t���
K�����8Ŭ)�'Ds{.����U=6#�ɢu���һ��%�r����{�l�����7:e1噠 2�U��O�N�(�y.zۏ�B�oɎC�~�ԓ�-����NR�$|���؎#K��(-R*o@�З{H���O�T���ʱ��Σ�,�� �[�����܍����I��ȈUc��ݚ�4W���Wi�������c�Łm��C*�&�v�o"$M�$7���pO5�=��Z�h~�z~=!C�U�d�[㒋ź2D*]�;����׃o�*c�%V�X~�9�_!r�2�O�W +ɻ�l_rⷉ���J�N��W\vg~'l�h�?��`!�4�U�Vyz�l���y1�E����S�ǔ�ږ��f{��bk�+� ���땶4,�(^�|��T�6	8��.&,D�IH}�"�O��X>��1��� ��R���D�;))�ķ&jݷ�D%�:jcSx3F�H��]��7䞮Mʺ/�B�.^}}���2�a�G(%Q�MgP�P�rD�m�������u�����O�L>�ߎ���8�w���r��ۀ��8r�+�q�Z- ��n����0G�o%؝1�h��>*+êYO7�gQo���k�K�18]Wٙ=��6}�b��t�� >W�IQ��n��,d��M$���Ţŭ�&ּb���L�4n���4=�u~�����Α�C��F]�m�q��%p(i��5֩����t��xcY�ׂ�3!.KI2ɑ��\S��e䕃d��yK���9j�/x)hi�Ӷh'�{9� �hΞ�<�y�D��\J7��;��n�=E����e�J�#ʴ7�;+)�o��!IU�����=q������oc6׏CV}�3_��t�ɴ�4�}��ǽ�W���V�Uu��f�-��?����W��M��ӅO�|XC�=1�T�tJXE8��4�r/M�� v����?��2��7��A*�Dm0)��k
����æ���4�Z�7ȫ��&�GJ�.c�[-�M[���x"�퉮�X	���8OT~@����-Cw��%8�6�_m���Og"���K�x1`��gч��Y��?����[���ZNC�ӊ�),J�z�vɏ�n�f��VA�t���'�ڹ1Q\@�~��s��R��>6" �E�6DƳ�$���3�� �!�PLq����=1�U���_t�B�����.?A��|\����+G�>���߿�[��I�kCA�(�.��|�y!��n/�Zm�e���\���4r+b�d9*ړ.R0g���n�L�0�Ɋ*��Iːw�)�]��%;00�`�z���&:�x�bm<��Њ"G.U��U; ��v��_Gtc���]ߐW)���U��i���
EC@)qu�Dr&�^0�^�(���L{�~��h�
h�A�@?:���z�5P���׸]�/�a
�]ǝu��EPCF�ȕ�[(I�ocDG�iuy�)V��F���oa���Cb�������"lbI4���u�8���Q���r�����Љ>��%>ɨ;�JH�S9^�u=E�p�\����W�њ:>% ?�ғu�D��q��jN�Z����"�O�29ˇ�}�T��I {�F!o�&�!�a��U��ko�[2�V861�y��:��cX�~L#�4�_X� ��`��a�C�#�Y@17ds�Gv���TDh2�xR]q��O��=�9���������t[6�΄�N�!lZ��N��i���y�2p��yF#_m/^0Le��^��}�����.����"nV�kҳ����:�t���\�՛��؄c��h?s������Ǭ1��]���Ǫ�֍��6��ڵ�8���9�M}rK��vo���
q����V}���q$Wɯ��+����n��aຒ����(_ُC��aq�T3�*L)�I����a7��(U��]R`��	>�0T �z��N��S*1�u[V{T�?㿶c�g-�ĥi�8�uŶ�4�ŘZ�V�b+��kd�%c `@�/7D�!0	�0mʽ���ӳ,ru�t'�pj���[+L�#vv4M�Z,(�(ģ
���jٜB'�͡ް�fF�k@�Z��w��Q�� |�iK��$'� I�d�!a�	�΁�57�/��؍����0(���'eeB�r�|�i�\����	{
�_���wP=:���մ0H��#�\���%�c��I��,>�}K�>����*ї��������]n���`�-���/����_���#?��b@�yh�4�hh���].�KǙ�ۉ{-,q|��
"��4R�(��m}����"���\n��dH�|8����:����*"� ��!��U+��,�s�c����|H��jda
X����$\b��j��cN{)�04	w>`��4Co�H�ڡF��C�m�X���Rе��SE��y�ӊ��/S����"�����=�W�����n(#��V�2���� �!�>;�YF�Wcn�	jYx�tc����d�6��}�eKİ[�Y�I�Ҭ����Z:���縦Ha�L�S��؇��s��Z��E��l����D�J��d)�$�\�
�9��p.��V�.��7kFF�r��>��hm�'m��hr��y�����w������ɮi��<[}��%]�����Yb��aI�h8"�/�=�[,CAs1\b+p˫a�M�bSH�ȆS�G��e�>v�@8�T�Wh dq�W�]��Jkz6���s�%�1�l��e�80q#c/#rpc]d�@y_���2�=)����	��U+#��|�gI�qݶ� ���Ų��k�s��]¶��:'��v�:6�������
a�����$�5Ol.�����
����S��~�VXvX�/����{G����h�p5%����q��P��L�O�_�B	8��y~{m��W`�_W�C����K�;����n�-�������O#��裸X�Mp�y���o��j9��k�8{�z��ZW��2n����&p���BVݹKk&u����A���o@d��r,����SF�8��C��ρ�5VG��n�>$��M�����i����}1+�m���Љ�W(*	=t���R?�;���m��M<�Z�i0͸�qn5IG�Z]<�i�mޞ�elhoi&�EY���#]'�F�	�8x=s͘�ʟG5�.�fYd�åM�;c^ �(�Ik�L�[F>����Q @�g\,�8]���!�}<�&9��|<�����>�8�͏$q��pw_�������_�*�w�'��bV���_N `���+.�}�a���T�dm�Rs�X6i���Yڇb�A�k���G�3���R��b��� ����>�4��f"��0LC�c��z81�H�k���q~<�^ͧ ��M�,����� C��<yI��-�ĝlX&D�{���]�$=�jnUd��$��t�e����:�ɡW�N�"���1�U#��j���I/*	�do�(�][�[T�,�X	�,rY�-P/��0����Ա����e��%�mZ��9;4d��J�c��]��T���~�#E�@��K��M~M K��i�޴H��~�<�h��RK�g'��\��*��͂��|��A�@i�_ۭ�AHN����r �FL{��e��g�t�xd%{v�'Ts�I�c��d���XR�A�Dݍ��M� �$��Y1%��9=�ⰑǏ^�G�N�@�n��� ��o�_�^ �H�寽�B$����*t� ����u�yeE�V���w�U\
24�L�r*�#6�Q>z@h��.NYsG�x����S�D (RC������Ak����#t�E���]�eT�9�LwJ��n���C��ga[�*�9��jK�r��u��wH��JW�� j��2`�����Q�cX@͘�r�;30��l��.I}8�,	d�r����%��k�l���N�"�>�(]~�_p� �3_��H%��hr�T�;�����SU���z�����|)}P��6����?�>q?����~��*�a�$�ڊ�+)�Ζ-x�g-��F(��\(TtsP��;��B� %Bt�F<��$b�,��o�'$v��s��7���Q�=W��M�}�!Ճ|��j�>{
Q��'�D��ǭ�n��w����W@q:W���V�dGɑ�.3����q����	���$U���Ӆ�4��V������$��6G+N����s��ı�UW�{��

���o� ?����{Y8��Ǟ� �+A���"Z�(>k���C���,������q���0��">��?�tnFz靓p���R(E����I�^�0���>U�!�&��*��9��6���[���(fUuꢪ�n��؈|M���v>�����wE��7w��X+����P Γ+�]#�M��}�Q��*����D�
����������Hȴ�ט���w}�c����=�iS*�j瞚�<��&������r�hV9K��鵝��!1�]���^�g�뚪4�ϝ$ª�%���+���e{�@�;G�P/'��9��[���i��������Q>�8�j.|�q��J�}���Cݵ��7Rf��"��}�$zz&��w�3H��&�vd
.n����Y:�%�@�?�9%�<j��/[̉������T.��J=��k�`��.��`|�
�ߖ D^s��26&���n�|������G�ܵ�20?�U�hv#`�Sy��*w<�6�4�'|FMA/|�&^K�Ob�OF�3a�	��X��mU����	:n�ST�_tl��IY
��u����w����^/�sV@��s|x�����r뫱����'b�S	�ݠe����b���6|y�Ҵ >�e��p1�RAW4�5�d*����o��nW�x�=�D�H����G�8+{gC�b���}��0@�������'
�\��4}��)/��-2��iL�u�S��SP}��!�<)�*P>3��a��\u�7/�S����5�n�R6]d�zo����2ͩ_�r�((�[��/��2X�C��Sp��8�<l��ђ��}����Q	�B��h40��aV���"��o�8Vd��㹶�<�Kw��%'��Zʻ>����^E���h��Իվ�����s����fi����Z�Ԇ�6�9}��O�����{�Xqň��`J!$0�uP�Trh��}e<��
z�P��v~�=�O�|��|x[��˳�ñ"6����h�T�ƣ٧Y�B<hQU�f���!��W�:��-L����q؛vG{���W��������M����>��K��;^�����j:��.�,��.;���_X��:�E� �ޑ�R9���5Ǵ�:�&����Nb<��nK�C�����aF������P)�!&2�O��i��6SW�k*�����[ݒ0-و)a�����